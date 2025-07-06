import 'dart:developer';
import 'dart:io';
import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'dart:async';

import 'package:chat/utils/services/api_service.dart';
import 'package:chat/utils/services/socket_io.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class LastChatRemoteDataSource {
  Future<ApiResponse<ChatModel>> getLastChats();
  Stream<ChatModel> getLastChatStream();
}

class LastChatRemoteDataSourceImp implements LastChatRemoteDataSource {
  final ApiService _apiService;
  final SocketIOService _socketIO;
  LastChatRemoteDataSourceImp(this._apiService, this._socketIO);

  @override
  Future<ApiResponse<ChatModel>> getLastChats() async {
    try {
      final chats = await _apiService.get('last-chats');
      return ApiResponse.fromJson(chats, ChatModel.fromJson);
    } on FirebaseAuthException catch (e) {
      log('GetLastChats error: FirebaseAuthException $e');
      throw ServerException(e.message ?? 'error');
    } on SocketException catch (e) {
      log('GetLastChats error: SocketException $e');
      throw ServerException(e.message);
    } catch (e) {
      log('GetLastChats error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<ChatModel> getLastChatStream() {
    try {
      final stream = _socketIO.chatStream;
      return stream.map((event) => ChatModel.fromJson(event));
    } catch (e) {
      log('SyncChats error: $e');
      throw ServerException(e.toString());
    }
  }
}
