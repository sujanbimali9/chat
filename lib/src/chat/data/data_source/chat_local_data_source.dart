import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/mixins/exception_handler_mixin.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/utils/database/daos/chat_table_query.dart';
import 'package:chat/utils/database/daos/user_table_query.dart';
import 'package:chat/utils/database/local_database.dart';

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
  Future<void> upsertConversation(ChatModel chat);
}

class ChatLocalDataSourceImp
    with LocalExceptionHandlerMixin
    implements ChatLocalDataSource {
  final ChatTableQuery _chatQuery;
  final UserTableQuery _userQuery;
  ChatLocalDataSourceImp(LocalDatabase localDatabase)
    : _chatQuery = localDatabase.chatTableQuery,
      _userQuery = localDatabase.userTableQuery;

  @override
  Future<ApiResponse<ChatModel, ChatPagination>> getChats(
    String chatId, {
    required int limit,
    required int? lastMessageSentTime,
  }) async {
    return await handleLocalException(() async {
      return await _chatQuery.getChats(
        chatId,
        limit: limit,
        lastMessageSentTime: lastMessageSentTime,
      );
    }, context: 'getChats');
  }

  @override
  Future<void> removeChat(ChatModel chat) async {
    return await handleLocalException(() async {
      await _chatQuery.deleteChat(chat.id);
    }, context: 'removeChat');
  }

  @override
  Future<void> addChat(ChatModel chat) async {
    return await handleLocalException(() async {
      await _chatQuery.insertChat(chat);
    }, context: 'addChat');
  }

  @override
  Future<void> addPending(ChatModel chat) async {
    return await handleLocalException(() async {
      await _chatQuery.insertChat(chat.copyWith(status: MessageStatus.sending));
    }, context: 'addPending');
  }

  @override
  Future<void> addChatsAll(List<ChatModel> chats) async {
    return await handleLocalException(() async {
      await _chatQuery.insertChats(chats);
    }, context: 'addChatsAll');
  }

  @override
  Future<void> updateRead(String chatId) async {
    return await handleLocalException(() async {
      await _chatQuery.updateRead(chatId);
    }, context: 'updateRead');
  }

  @override
  Future<List<ChatModel>> getPendingChat() async {
    return await handleLocalException(() async {
      return await _chatQuery.getPendingChats();
    }, context: 'getPendingChat');
  }

  @override
  Future<void> upsertConversation(ChatModel chat) {
    return handleLocalException(() async {
      await _userQuery.upsertConversation(chat);
    }, context: 'addLastChat');
  }
}
