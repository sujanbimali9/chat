import 'dart:developer';

import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/utils/database/daos/chat_table_query.dart';
import 'package:chat/utils/database/daos/user_table_query.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:drift/native.dart';

abstract interface class ChatLocalDataSource {
  Future<ApiResponse<ChatModel, ChatPagination>> getChats(
    String chatId, {
    required int limit,
    required int? lastMessageSentTime,
  });
  Future<void> removeChat(ChatModel chat);
  Future<void> updateRead(String chatId);
  Future<void> addChat(ChatModel chat);
  Future<void> addChatsAll(List<ChatModel> chats);
  Future<void> addPending(ChatModel chat);
  Future<List<ChatModel>> getPendingChat();
  Future<void> addLastChat(ChatModel chat);
}

class ChatLocalDataSourceImp implements ChatLocalDataSource {
  final ChatTableQuery _chatQuery;
  final UserTableQuery _userQuery;
  ChatLocalDataSourceImp(LocalDatabase localDatabase)
    : _chatQuery = localDatabase.chatTableQuery,
      _userQuery = localDatabase.userTableQuery;

  Future<T> _handleLocalException<T>(
    Future<T> Function() fn, {
    String context = '',
  }) async {
    try {
      return await fn();
    } on SqliteException catch (e) {
      log(
        'SQLite Exception: ${e.message}',
        name: 'ChatLocalDataSourceImp.$context',
      );
      throw CacheException(e.message);
    } catch (e) {
      log('Unexpected Exception: $e', name: 'ChatLocalDataSourceImp.$context');
      throw CacheException(e.toString());
    }
  }

  @override
  Future<ApiResponse<ChatModel, ChatPagination>> getChats(
    String chatId, {
    required int limit,
    required int? lastMessageSentTime,
  }) async {
    return await _handleLocalException(() async {
      return await _chatQuery.getChats(
        chatId,
        limit: limit,
        lastMessageSentTime: lastMessageSentTime,
      );
    }, context: 'getChats');
  }

  @override
  Future<void> removeChat(ChatModel chat) async {
    return await _handleLocalException(() async {
      await _chatQuery.deleteChat(chat.id);
    }, context: 'removeChat');
  }

  @override
  Future<void> addChat(ChatModel chat) async {
    return await _handleLocalException(() async {
      await _chatQuery.insertChat(chat);
    }, context: 'addChat');
  }

  @override
  Future<void> addPending(ChatModel chat) async {
    return await _handleLocalException(() async {
      await _chatQuery.insertChat(chat.copyWith(status: MessageStatus.sending));
    }, context: 'addPending');
  }

  @override
  Future<void> addChatsAll(List<ChatModel> chats) async {
    return await _handleLocalException(() async {
      await _chatQuery.insertChats(chats);
    }, context: 'addChatsAll');
  }

  @override
  Future<void> updateRead(String chatId) async {
    return await _handleLocalException(() async {
      await _chatQuery.updateRead(chatId);
    }, context: 'updateRead');
  }

  @override
  Future<List<ChatModel>> getPendingChat() async {
    return await _handleLocalException(() async {
      return await _chatQuery.getPendingChats();
    }, context: 'getPendingChat');
  }

  @override
  Future<void> addLastChat(ChatModel chat) {
    return _handleLocalException(() async {
      await _userQuery.insertLastChat(chat);
    }, context: 'addLastChat');
  }
}
