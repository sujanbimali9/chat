import 'package:chat/src/chat/data/model/chat_model.dart';

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
}

class ChatRemoteDataSourceImp extends ChatRemoteDataSource {
  @override
  Future<Map<int, ChatModel>> getChats(String chatId,
      {int? limit, int? offset}) {
    throw UnimplementedError();
  }

  @override
  Stream<Map<int, ChatModel>> getChatsStream(String chatId,
      {int? limit, int? offset}) {
    throw UnimplementedError();
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
  Future<ChatModel> sendFile(ChatModel chat) {
    throw UnimplementedError();
  }

  @override
  Future<ChatModel> sendImage(ChatModel chat) {
    throw UnimplementedError();
  }

  @override
  Future<ChatModel> sendText(ChatModel chat) {
    throw UnimplementedError();
  }

  @override
  Future<ChatModel> sendVideo(ChatModel chat) {
    throw UnimplementedError();
  }
}
