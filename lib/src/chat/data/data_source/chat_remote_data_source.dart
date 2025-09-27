import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/chat/data/model/media_model.dart';
import 'package:chat/utils/generator/media/image_metadata.dart';
import 'package:chat/utils/services/api_service.dart';
import 'package:chat/utils/services/socket_io.dart';
import 'package:flutter/services.dart';

abstract interface class ChatRemoteDataSource {
  Future<ChatModel> sendMessage(ChatModel chat);
  Future<ChatModel> sendMessageHttp(ChatModel chat);
  Future<List<MediaModel>> sendFiles(List<MediaModel> media, String chatId);
  Future<List<MediaModel>> sendImages(List<MediaModel> media, String chatId);
  Future<List<MediaModel>> sendVideos(List<MediaModel> media, String chatId);
  Future<MediaModel> sendAudio(MediaModel media, String chatId);
  Stream<ChatModel> getChatsStream(String chatId);
  Future<ApiResponse<ChatModel, ChatPagination>> getChats(
    String chatId, {
    required int limit,
    required int? lastMessagesentTime,
  });
  Future<void> removeChat(ChatModel chat);
}

class ChatRemoteDataSourceImp extends ChatRemoteDataSource {
  final ApiService _apiService;
  final SocketIOService _socketIO;
  ChatRemoteDataSourceImp(this._apiService, this._socketIO);

  FutureOr<T> _handleException<T>(
    Future<T> Function() operation, {
    String context = '',
  }) async {
    try {
      return await operation();
    } on TimeoutException catch (e) {
      log(
        'Timeout Exception: ${e.message}',
        name: 'ChatRemoteDataSource.$context',
      );
      throw ServerException(e.message);
    } on SocketException catch (e) {
      log(
        'Socket Exception: ${e.message}',
        name: 'ChatRemoteDataSource.$context',
      );
      throw ServerException(e.message);
    } on ServerException catch (e) {
      log(
        'Server Exception: ${e.message}',
        name: 'ChatRemoteDataSource.$context',
      );
      rethrow;
    } catch (e) {
      log('Unexpected Exception: $e', name: 'ChatRemoteDataSource.$context');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ApiResponse<ChatModel, ChatPagination>> getChats(
    String chatId, {
    required int limit,
    required int? lastMessagesentTime,
  }) async {
    return await _handleException(() async {
      final chats = await _apiService.get(
        'chats/$chatId',
        query: {'limit': limit, 'lastMessagesentTime': lastMessagesentTime},
      );

      return ApiResponse.fromJson(
        chats,
        ChatModel.fromJson,
        ChatPagination.fromJson,
      );
    }, context: 'GetChats');
  }

  @override
  Stream<ChatModel> getChatsStream(String chatId) {
    try {
      final chat = _socketIO.chatStream.where(
        (event) => event['chatId'] == chatId,
      );

      return chat.map((event) => ChatModel.fromJson(event));
    } on SocketException catch (e) {
      log('GetChatStream error: SocketException $e');
      throw ServerException(e.message);
    } catch (e) {
      log('GetChatStream error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> removeChat(ChatModel chat) async {
    throw UnimplementedError();
  }

  @override
  Future<MediaModel> sendAudio(MediaModel media, String chatId) async {
    throw UnimplementedError();
  }

  @override
  Future<List<MediaModel>> sendFiles(
    List<MediaModel> media,
    String chatId,
  ) async {
    return await _handleException(() async {
      final url = await _uploadFiles(
        media.map((e) => e.url).toList(),
        '$chatId/file/',
      );
      return media.indexed.map((e) => e.$2.copyWith(url: url[e.$1])).toList();
    }, context: 'SendFile');
  }

  @override
  Future<List<MediaModel>> sendImages(
    List<MediaModel> media,
    String chatId,
  ) async {
    return await _handleException(() async {
      final urls = await _uploadImages(
        media.map((e) => e.url).toList(),
        '$chatId/image/',
      );
      return media.indexed.map((e) => e.$2.copyWith(url: urls[e.$1])).toList();
    }, context: 'SendImage');
  }

  @override
  Future<ChatModel> sendMessage(ChatModel chat) async {
    return await _handleException(() async {
      final res = await _socketIO.sendMessage(chat.toJson());

      return ChatModel.fromJson(res);
    }, context: 'SendMessage');
  }

  @override
  Future<List<MediaModel>> sendVideos(
    List<MediaModel> media,
    String chatId,
  ) async {
    return await _handleException(() async {
      final videoUrl = _uploadFiles(
        media.map((e) => e.url).toList(),
        '$chatId/video/',
      );
      final thumbnailUrl = _uploadFiles(
        media.map((e) => e.metadata.thumbnail!).toList(),
        '$chatId/video/thumbnail/',
      );
      final urls = await Future.wait([videoUrl, thumbnailUrl]);
      return media.indexed.map((e) {
        final video = e.$2;
        final thumbnail = urls[1][e.$1];
        return video.copyWith(
          url: urls[0][e.$1],
          metadata: video.metadata.copyWith(thumbnail: thumbnail),
        );
      }).toList();
    }, context: 'SendVideo');
  }

  Future<List<String>> _uploadFiles(List<String> filesPath, String path) async {
    try {
      final urls = await _apiService.uploadFiles(
        filesPath,
        storagePath: path,
        url: 'uploads',
      );
      return urls['data'].cast<String>();
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> _compressImage(String path) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_imageCompressionIsolate, receivePort.sendPort);
    final sendPort = await receivePort.first as SendPort;
    final resultPort = ReceivePort();
    final rootToken = RootIsolateToken.instance!;
    sendPort.send([path, resultPort.sendPort, rootToken]);
    final image = await resultPort.first;
    if (image == null) {
      throw Exception('Failed to compress image');
    }
    return image;
  }

  static Future<void> _imageCompressionIsolate(SendPort sendPort) async {
    final receivePort = ReceivePort();

    sendPort.send(receivePort.sendPort);

    final List message = await receivePort.first;
    final String path = message[0];
    final SendPort responsePort = message[1];
    final rootToken = message[2];
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootToken);

    try {
      final compressedImage = await ImageMetadata.compressImage(path);
      if (compressedImage == null) {
        throw Exception('Failed to compress image');
      }

      responsePort.send(compressedImage);
    } catch (e) {
      responsePort.send(null);
    }
  }

  Future<List<String>> _uploadImages(
    List<String> path,
    String supabasePath,
  ) async {
    try {
      final pendingImageCompressions = <Future<Uint8List>>[];
      for (final p in path) {
        pendingImageCompressions.add(_compressImage(p));
      }
      final compressedImage = await Future.wait(pendingImageCompressions);
      final res = await _apiService.uploadFilesData(
        compressedImage,
        storagePath: supabasePath,
        url: 'uploads',
      );
      return res['data'].cast<String>();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChatModel> sendMessageHttp(ChatModel chat) async {
    return await _handleException(() async {
      log('Sending message via HTTP: ${chat.toJson()}');
      final res = await _apiService.post('chats/sendChat', data: chat.toJson());
      return ChatModel.fromJson(res);
    }, context: 'SendMessageHttp');
  }
}
