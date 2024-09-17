import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/exception/server_exception.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/chat/data/data_source/chat_remote_data_source.dart';
import 'package:chat/src/chat/data/data_source/local_remote_data_source.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:chat/utils/helper/network_info.dart';
import 'package:fpdart/fpdart.dart';

class ChatRepositoryImp implements ChatRepository {
  final ChatRemoteDataSource _chatRemoteDataSource;
  final ChatLocalDataSource _chatLocalDataSource;
  final NetworkInfo _networkInfo;

  ChatRepositoryImp(
    ChatRemoteDataSource chatRemoteDataSource,
    ChatLocalDataSource chatLocalDataSource,
    NetworkInfo networkInfo,
  )   : _chatRemoteDataSource = chatRemoteDataSource,
        _chatLocalDataSource = chatLocalDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, ChatModel>> sendAudio(ChatModel chat) async {
    try {
      if (!_networkInfo.checkConnection()) {
        await _chatLocalDataSource.addPending(chat);
        return left(Failure('No internet connection'));
      }
      final result = await _chatRemoteDataSource.sendAudio(chat);
      await _chatLocalDataSource.addChat(result);
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
      if (!_networkInfo.checkConnection()) {
        await _chatLocalDataSource.addPending(chat);
        return left(Failure('No internet connection'));
      }
      final result = await _chatRemoteDataSource.sendImage(chat);
      await _chatLocalDataSource.addChat(result);

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
      if (!_networkInfo.checkConnection()) {
        await _chatLocalDataSource.addPending(chat);
        return left(Failure('No internet connection'));
      }
      final result = await _chatRemoteDataSource.sendText(chat);
      await _chatLocalDataSource.addChat(result);

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
      if (!_networkInfo.checkConnection()) {
        await _chatLocalDataSource.addPending(chat);
        return left(Failure('No internet connection'));
      }
      final result = await _chatRemoteDataSource.sendVideo(chat);
      await _chatLocalDataSource.addChat(result);
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
      await _chatLocalDataSource.removeChat(chat);
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
      if (!_networkInfo.checkConnection()) {
        await _chatLocalDataSource.addPending(chat);
        return left(Failure('No internet connection'));
      }
      final result = await _chatRemoteDataSource.sendFile(chat);
      await _chatLocalDataSource.addChat(result);
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
      if (!_networkInfo.checkConnection()) {
        final chats = await _chatLocalDataSource.getChats(chatId,
            limit: limit, offset: offset);
        if (chats.isNotEmpty) {
          return right(chats);
        }
      }
      final result = await _chatRemoteDataSource.getChats(
        chatId,
        limit: limit,
        offset: offset,
      );
      await _chatLocalDataSource.addChatsAll(result.values.toList());

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
      final result =
          await _chatLocalDataSource.updateRead({'chat_id': chatId, 'read': 1});
      await _chatRemoteDataSource.updateReadStatus(chatId);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
