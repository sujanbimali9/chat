import 'dart:developer';

import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/home/data/datasource/last_chat_local_data_source.dart';
import 'package:chat/src/home/data/datasource/last_chat_remote_data_source.dart';
import 'package:chat/src/home/domain/repository/last_chat_repository.dart';
import 'package:chat/utils/helper/network_info.dart';
import 'package:fpdart/fpdart.dart';

class LastChatRepositoryImp implements LastChatRepository {
  final LastChatRemoteDataSource _lastChatRemoteDataSource;
  final LastChatLocalDataSource _lastChatLocalDataSource;
  final NetworkInfo _networkInfo;

  LastChatRepositoryImp(
    this._lastChatRemoteDataSource,
    this._networkInfo,
    this._lastChatLocalDataSource,
  );

  @override
  Future<Either<Failure, ApiResponse<Chat>>> getLastChats(
      {required int limit, required int offset}) async {
    try {
      if (!_networkInfo.checkConnection()) {
        final res = await _lastChatLocalDataSource.getLastChats(
            limit: limit, offset: offset);
        return right(res.map(Chat.fromChatModel));
      }

      final res = await _lastChatRemoteDataSource.getLastChats();
      return right(res.map(Chat.fromChatModel));
    } on ServerException catch (e) {
      log('GetLastChats error: $e');
      return left(Failure(e.message));
    } catch (e) {
      log('GetLastChats error: $e');
      return left(Failure(e.toString()));
    }
  }

  @override
  Either<Failure, Stream<Chat>> getLastChatsStream() {
    try {
      final res = _lastChatRemoteDataSource.getLastChatStream();
      return right(res.map(Chat.fromChatModel));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
