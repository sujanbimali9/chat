import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ChatRepository {
  Future<Either<Failure, Chat>> sendText(ChatModel chat);
  Future<Either<Failure, Chat>> sendImage(ChatModel chat);
  Future<Either<Failure, Chat>> sendVideo(ChatModel chat);
  Future<Either<Failure, Chat>> sendAudio(ChatModel chat);
  Either<Failure, Stream<Map<int, Chat>>> getChatsStream(String chatId,
      {int? limit, int? offset});
  Future<Either<Failure, Map<int, Chat>>> getChats(String chatId,
      {int? limit, int? offset});
  Future<Either<Failure, void>> removeChat(ChatModel chat);
  Future<Either<Failure, Chat>> sendFile(ChatModel chat);
  Future<Either<Failure, void>> updateReadStatus(String chatId);
}
