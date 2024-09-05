import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/exception/server_exception.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/chat/data/data_source/chat_remote_data_source.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChatRepositoryImp implements ChatRepository {
  final ChatRemoteDataSource _chatRemoteDataSource;

  ChatRepositoryImp(ChatRemoteDataSource chatRemoteDataSource)
      : _chatRemoteDataSource = chatRemoteDataSource;
  @override
  Future<Either<Failure, ChatModel>> sendAudio(ChatModel chat) async {
    try {
      final result = await _chatRemoteDataSource.sendAudio(chat);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatModel>> sendImage(ChatModel chat) async {
    try {
      final result = await _chatRemoteDataSource.sendImage(chat);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatModel>> sendText(ChatModel chat) async {
    try {
      final result = await _chatRemoteDataSource.sendText(chat);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatModel>> sendVideo(ChatModel chat) async {
    try {
      final result = await _chatRemoteDataSource.sendVideo(chat);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeChat(final ChatModel chat) async {
    try {
      final result = await _chatRemoteDataSource.removeChat(chat);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Either<Failure, Stream<Map<int, ChatModel>>> getChatsStream(String chatId,
      {int? limit, int? offset}) {
    try {
      final result = _chatRemoteDataSource.getChatsStream(chatId,
          limit: limit, offset: offset);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Chat>> sendFile(ChatModel chat) async {
    try {
      final result = await _chatRemoteDataSource.sendFile(chat);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<int, Chat>>> getChats(String chatId,
      {int? limit, int? offset}) async {
    try {
      final result = await _chatRemoteDataSource.getChats(
        chatId,
        limit: limit,
        offset: offset,
      );
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateReadStatus(String chatId) async {
    try {
      final result = await _chatRemoteDataSource.updateReadStatus(chatId);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
