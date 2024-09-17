import 'package:chat/core/exception/server_exception.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/utils/database/local_database.dart';

abstract interface class ChatLocalDataSource {
  Future<Map<int, ChatModel>> getChats(
    String chatId, {
    int? limit,
    int? offset,
  });
  Future<void> removeChat(ChatModel chat);
  Future<void> updateChat({Map<String, dynamic>? chatData, ChatModel? chat});
  Future<void> updateRead(Map<String, dynamic> chatData);
  Future<void> addChat(ChatModel chat);
  Future<void> addChatsAll(List<ChatModel> chats);
  Future<void> addPending(ChatModel chat);
}

class ChatLocalDataSourceImp implements ChatLocalDataSource {
  final LocalDatabase _localDatabase;

  ChatLocalDataSourceImp(LocalDatabase localDatabase)
      : _localDatabase = localDatabase;

  @override
  Future<Map<int, ChatModel>> getChats(String chatId,
      {int? limit, int? offset}) async {
    final chats =
        await _localDatabase.getChats(chatId, limit: limit, offset: offset);
    return chats;
  }

  @override
  Future<void> removeChat(ChatModel chat) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateChat(
      {Map<String, dynamic>? chatData, ChatModel? chat}) async {
    await _localDatabase.updateChat(chat: chat, data: chatData);
  }

  @override
  Future<void> addChat(ChatModel chat) async {
    await _localDatabase.insertChat(chat);
  }

  @override
  Future<void> addPending(ChatModel chat) async {
    await _localDatabase.insertPendingChat(chat);
  }

  @override
  Future<void> addChatsAll(List<ChatModel> chats) async {
    try {
      await _localDatabase.insertChats(chats);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateRead(Map<String, dynamic> chatData) async {
    try {
      await _localDatabase.upateRead(chatData);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
