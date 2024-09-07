import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:chat/core/exception/server_exception.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/utils/generator/media/image_metadata.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

abstract interface class ChatRemoteDataSource {
  Future<ChatModel> sendText(ChatModel chat);
  Future<ChatModel> sendFile(ChatModel chat);
  Future<ChatModel> sendImage(ChatModel chat);
  Future<ChatModel> sendVideo(ChatModel chat);
  Future<ChatModel> sendAudio(ChatModel chat);
  Stream<Map<int, ChatModel>> getChatsStream(
    String chatId, {
    int? limit,
    int? offset,
  });
  Future<Map<int, ChatModel>> getChats(
    String chatId, {
    int? limit,
    int? offset,
  });
  Future<void> removeChat(ChatModel chat);
  Future<void> updateReadStatus(String chatId);
}

class ChatRemoteDataSourceImp extends ChatRemoteDataSource {
  final SupabaseClient _client;

  ChatRemoteDataSourceImp(SupabaseClient supabaseClient)
      : _client = supabaseClient;
  @override
  Future<Map<int, ChatModel>> getChats(String chatId,
      {int? limit, int? offset}) async {
    try {
      final res = _client
          .from('chats')
          .select('*')
          .eq('chat_id', chatId)
          .order('sent_time', ascending: false)
          .limit(limit ?? 20)
          .range(offset ?? 0, (offset ?? 0) + (limit ?? 20));

      final resonse = await res;
      final chats = <int, ChatModel>{};

      for (var e in resonse) {
        chats[e['sent_time']] = ChatModel.fromJson(e);
      }

      return chats;
    } on SocketException catch (e) {
      log('GetChats error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('GetChats error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('GetChats error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<Map<int, ChatModel>> getChatsStream(String chatId,
      {int? limit, int? offset}) {
    try {
      final res = _client
          .from('chats')
          .stream(primaryKey: ['id'])
          .eq('chat_id', chatId)
          .order('sent_time', ascending: false)
          .limit(limit ?? 10);

      return res.map((dataList) {
        final chats = <int, ChatModel>{};

        for (var data in dataList) {
          final chat = ChatModel.fromJson(data);
          chats[data['sent_time']] = chat;
        }

        return chats;
      });
    } on SocketException catch (e) {
      log('GetChatsStream error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('GetChatsStream error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('GetChatsStream error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> removeChat(ChatModel chat) {
    throw UnimplementedError();
  }

  @override
  Future<ChatModel> sendAudio(ChatModel chat) {
    throw UnimplementedError();
  }

  @override
  Future<ChatModel> sendFile(ChatModel chat) async {
    try {
      final url = await _uploadFile(
          chat.msg, '${chat.chatId}/file/${chat.metadata?.title}');
      final updatedChat = chat.copyWith(msg: url);
      final res =
          _client.from('chats').upsert(updatedChat.toJson()).select().single();
      final resonse = await res;
      _sendNotification(chat);

      return ChatModel.fromJson(resonse);
    } on SocketException catch (e) {
      log('SendFile error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('SendFile error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('SendFile error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ChatModel> sendImage(ChatModel chat) async {
    try {
      final url = await _uploadImage(
          chat.msg, '${chat.chatId}/image/${chat.msg.split('/').last}');
      final updatedChat = chat.copyWith(msg: url);
      final res =
          _client.from('chats').upsert(updatedChat.toJson()).select().single();
      final resonse = await res;
      _sendNotification(chat);

      return ChatModel.fromJson(resonse);
    } on SocketException catch (e) {
      log('SendImage error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('SendImage error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('SendImage error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ChatModel> sendText(ChatModel chat) async {
    try {
      final res = _client.from('chats').upsert(chat.toJson()).select().single();
      final resonse = await res;
      _sendNotification(chat);
      return ChatModel.fromJson(resonse);
    } on SocketException catch (e) {
      log('SendText error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('SendText error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('SendText error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ChatModel> sendVideo(ChatModel chat) async {
    try {
      final videoUrl = await _uploadFile(chat.msg, '${chat.chatId}/video');

      final thumbnailUrl = await _uploadFile(
        (await VideoThumbnail.thumbnailFile(video: chat.msg))!,
        '${chat.chatId}/image/${chat.metadata!.thumbnail!.split('/').last}',
      );

      final updatedChat = chat.copyWith(
          msg: videoUrl,
          metadata: chat.metadata?.copyWith(thumbnail: thumbnailUrl));
      final res =
          _client.from('chats').upsert(updatedChat.toJson()).select().single();
      final resonse = await res;
      _sendNotification(chat);
      return ChatModel.fromJson(resonse);
    } on SocketException catch (e) {
      log('SendVideo error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('SendVideo error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('SendVideo error: $e');
      throw ServerException(message: e.toString());
    }
  }

  Future<String> _uploadFile(String path, String supabasePath) async {
    try {
      await _client.storage.from('chats').upload(supabasePath, File(path));
      return _client.storage.from('chats').getPublicUrl(supabasePath);
    } catch (e) {
      return _client.storage.from('chats').getPublicUrl(supabasePath);
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

  Future<String> _uploadImage(String path, String supabasePath) async {
    final compressedImage = await _compressImage(path);
    try {
      await _client.storage
          .from('chats')
          .uploadBinary(supabasePath, compressedImage);
      return _client.storage.from('chats').getPublicUrl(supabasePath);
    } catch (e) {
      return _client.storage.from('chats').getPublicUrl(supabasePath);
    }
  }

  @override
  Future<void> updateReadStatus(String chatId) async {
    try {
      await _client.from('chats').update({'read': true}).eq('chat_id', chatId);
    } on SocketException catch (e) {
      log('UpdateReadStatus error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('UpdateReadStatus error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('UpdateReadStatus error: $e');
      throw ServerException(message: e.toString());
    }
  }

  Future<void> _sendNotification(ChatModel chat) async {}
}
