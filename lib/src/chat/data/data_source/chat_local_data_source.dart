import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/utils/database/daos/chat_table_query.dart';
import 'package:chat/utils/database/daos/last_chat_table_query.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:drift/native.dart';

abstract interface class ChatLocalDataSource {
  Future<ApiResponse<ChatModel>> getChats(String chatId,
      {required int limit, required int offset});
  Future<void> removeChat(ChatModel chat);
  Future<void> updateRead(String chatId);
  Future<void> addChat(ChatModel chat);
  Future<void> addChatsAll(List<ChatModel> chats);
  Future<void> addPending(ChatModel chat);
  Future<List<ChatModel>> getPendingChat();
  Future<void> addLastChat(ChatModel chat);
  Stream<List<ChatModel>> getChatsStream(
    String chatId, {
    int? limit,
    int? offset,
  });
}

class ChatLocalDataSourceImp implements ChatLocalDataSource {
  final ChatTableQuery _chatQuery;
  final LastChatTableQuery _lastChatQuery;
  ChatLocalDataSourceImp(LocalDatabase localDatabase)
      : _chatQuery = localDatabase.chatTableQuery,
        _lastChatQuery = localDatabase.lastChatTableQuery;

  Future<T> _handleLocalException<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on SqliteException catch (e) {
      throw CacheException(e.message);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<ApiResponse<ChatModel>> getChats(String chatId,
      {required int limit, required int offset}) async {
    return await _handleLocalException(() async {
      return await _chatQuery.getChats(chatId, limit: limit, offset: offset);
    });
  }

  @override
  Future<void> removeChat(ChatModel chat) async {
    return await _handleLocalException(() async {
      await _chatQuery.deleteChat(chat.id);
    });
  }

  @override
  Future<void> addChat(ChatModel chat) async {
    return await _handleLocalException(() async {
      await _chatQuery.insertChat(chat);
    });
  }

  @override
  Future<void> addPending(ChatModel chat) async {
    return await _handleLocalException(() async {
      await _chatQuery.insertChat(chat.copyWith(status: MessageStatus.sending));
    });
  }

  @override
  Future<void> addChatsAll(List<ChatModel> chats) async {
    return await _handleLocalException(() async {
      await _chatQuery.insertChats(chats);
    });
  }

  @override
  Future<void> updateRead(String chatId) async {
    return await _handleLocalException(() async {
      await _chatQuery.updateRead(chatId);
    });
  }

  @override
  Future<List<ChatModel>> getPendingChat() async {
    return await _handleLocalException(() async {
      return await _chatQuery.getPendingChats();
    });
  }

  @override
  Future<void> addLastChat(ChatModel chat) {
    return _handleLocalException(() async {
      await _lastChatQuery.insertLastChat(chat);
    });
  }

  @override
  Stream<List<ChatModel>> getChatsStream(String chatId,
      {int? limit, int? offset}) {
    try {
      return _chatQuery.getChatsStream(chatId, limit: limit, offset: offset);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
