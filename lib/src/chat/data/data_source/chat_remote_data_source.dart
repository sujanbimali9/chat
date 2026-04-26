import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/core/mixins/exception_handler_mixin.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/chat/data/model/media_model.dart';
import 'package:chat/utils/constant/type_def.dart';
import 'package:chat/utils/generator/media/image_metadata.dart';
import 'package:chat/utils/services/api_service.dart';
import 'package:chat/utils/services/socket_io.dart';
import 'package:flutter/services.dart';
import 'package:v_video_compressor/v_video_compressor.dart';

abstract interface class ChatRemoteDataSource {
  Future<ChatModel> sendMessage(ChatModel chat);
  Future<ChatModel> sendMessageHttp(ChatModel chat);
  Future<List<MediaModel>> sendFiles(
    List<MediaModel> media,
    String chatId, {
    ProgressCallback? progress,
  });
  Future<List<MediaModel>> sendImages(
    List<MediaModel> media,
    String chatId, {
    ProgressCallback? progress,
  });
  Future<List<MediaModel>> sendVideos(
    List<MediaModel> media,
    String chatId, {
    ProgressCallback? progress,
  });
  Future<MediaModel> sendAudio(
    MediaModel media,
    String chatId, {
    ProgressCallback? progress,
  });
  Stream<ChatModel> getChatsStream(String chatId);
  Future<ApiResponse<ChatModel, ChatPagination>> getChats(
    String chatId, {
    required int limit,
    required int? lastMessagesentTime,
  });
  Future<void> removeChat(ChatModel chat);
}

class ChatRemoteDataSourceImp
    with NetworkExceptionHandlerMixin
    implements ChatRemoteDataSource {
  final ApiService _apiService;
  final SocketIOService _socketIO;
  ChatRemoteDataSourceImp(this._apiService, this._socketIO);

  @override
  Future<ApiResponse<ChatModel, ChatPagination>> getChats(
    String chatId, {
    required int limit,
    required int? lastMessagesentTime,
  }) async {
    return await handleNetworkException(() async {
      final chats = await _apiService.get(
        'chats',
        query: {
          'chatId': chatId,
          'limit': limit,
          'lastMessagesentTime': lastMessagesentTime,
        },
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
  Future<MediaModel> sendAudio(
    MediaModel media,
    String chatId, {
    ProgressCallback? progress,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<List<MediaModel>> sendFiles(
    List<MediaModel> media,
    String chatId, {
    ProgressCallback? progress,
  }) async {
    return await handleNetworkException(() async {
      final url = await _uploadFiles(
        media.map((e) => e.url).toList(),
        '$chatId/file/',
        progress: progress,
      );
      return media.indexed.map((e) => e.$2.copyWith(url: url[e.$1])).toList();
    }, context: 'SendFile');
  }

  @override
  Future<List<MediaModel>> sendImages(
    List<MediaModel> media,
    String chatId, {
    ProgressCallback? progress,
  }) async {
    return await handleNetworkException(() async {
      final urls = await _uploadImages(
        media.map((e) => e.url).toList(),
        '$chatId/image/',
        progress: progress,
      );
      return media.indexed.map((e) => e.$2.copyWith(url: urls[e.$1])).toList();
    }, context: 'SendImage');
  }

  @override
  Future<ChatModel> sendMessage(ChatModel chat) async {
    return await handleNetworkException(() async {
      final res = await _socketIO.sendMessage(chat.toJson());

      return ChatModel.fromJson(res);
    }, context: 'SendMessage');
  }

  @override
  Future<List<MediaModel>> sendVideos(
    List<MediaModel> media,
    String chatId, {
    ProgressCallback? progress,
  }) async {
    assert(media.isNotEmpty, 'Media list cannot be empty');
    assert(
      media.every((e) => e.metadata.thumbnail != null),
      'Thumbnail is required for video upload',
    );
    return await handleNetworkException(() async {
      int videoSent = 0;
      int videoTotal = 1;
      int thumbSent = 0;
      int thumbTotal = 1;

      void updateProgress() {
        if (progress != null) {
          final sent = videoSent + thumbSent;
          final total = videoTotal + thumbTotal;
          progress(sent, total);
        }
      }

      final stopwatch = Stopwatch()..start();
      final compressedVideos = await media.map((value) async {
        return await VVideoCompressor().compressVideo(
          value.url,
          VVideoCompressionConfig.medium(),
        );
      }).wait;

      stopwatch.stop();
      log('Video compression took: ${stopwatch.elapsedMilliseconds} ms');
      if (compressedVideos.isEmpty) {
        log('Video compression failed: No videos returned');
        throw Exception('Video compression failed');
      }
      log(
        'Video compressed and size decreased from ${compressedVideos.firstOrNull?.originalSizeFormatted} to ${compressedVideos.firstOrNull?.compressedSizeFormatted}',
      );
      final videoUrl = _uploadFiles(
        compressedVideos
            .whereType<VVideoCompressionResult>()
            .map((e) => e.compressedFilePath)
            .toList(),
        '$chatId/video/',
        progress: (sent, total) {
          videoSent = sent;
          videoTotal = total;
          updateProgress();
        },
      );

      final thumbnailUrl = _uploadFiles(
        media.map((e) => e.metadata.thumbnail!).toList(),
        '$chatId/video/thumbnail/',
        progress: (sent, total) {
          thumbSent = sent;
          thumbTotal = total;
          updateProgress();
        },
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

  Future<List<String>> _uploadFiles(
    List<String> filesPath,
    String path, {
    void Function(int sent, int total)? progress,
  }) async {
    try {
      final urls = await _apiService.uploadFiles(
        filesPath,
        storagePath: path,
        url: 'uploads',
        progress: progress,
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
    String storagePath, {
    ProgressCallback? progress,
  }) async {
    try {
      final pendingImageCompressions = <Future<Uint8List>>[];
      for (final p in path) {
        pendingImageCompressions.add(_compressImage(p));
      }
      final compressedImage = await Future.wait(pendingImageCompressions);
      final res = await _apiService.uploadFilesData(
        compressedImage,
        storagePath: storagePath,
        url: 'uploads',
        progress: progress,
      );
      return res['data'].cast<String>();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChatModel> sendMessageHttp(ChatModel chat) async {
    return await handleNetworkException(() async {
      log('Sending message via HTTP: ${chat.toJson()}');
      final res = await _apiService.post('chats/sendChat', data: chat.toJson());
      return ChatModel.fromJson(res);
    }, context: 'SendMessageHttp');
  }
}
