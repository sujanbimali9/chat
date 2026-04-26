import 'dart:io';

import 'package:chat/core/common/model/conversation.dart';
import 'package:chat/core/mixins/exception_handler_mixin.dart';
import 'package:fpdart/fpdart.dart';

import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/home/data/datasource/user_local_data_source.dart';
import 'package:chat/src/home/data/datasource/user_remote_data_source.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:chat/utils/helper/network_info.dart';

class UserRepositoryImp with ExceptionHandlerMixin implements UserRepository {
  final UserRemoteDataSource _userRemoteDataSource;
  final UserLocalDataSource _userLocalDataSource;
  final NetworkInfo _networkInfo;

  UserRepositoryImp(
    this._userRemoteDataSource,
    this._userLocalDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, ApiResponse<User, UserPagination>>> getAllUsers({
    required int limit,
    required int offset,
    bool local = false,
  }) async {
    return await handleException(() async {
      if (local) {
        final res = await _userLocalDataSource.getAllUser(
          limit: limit,
          offset: offset,
        );
        return res;
      }
      final users = await _userRemoteDataSource.getAllUsers(
        limit: limit,
        offset: offset,
      );

      await _userLocalDataSource.saveUsers(users.data);
      return users;
    }, context: 'getAllUsers');
  }

  @override
  Future<Either<Failure, ApiResponse<Conversation, ConversationPagination>>>
  getConversationHistory({
    required int limit,
    required int? lastInteractedAt,
    bool local = false,
  }) async {
    return await handleException(() async {
      if (local) {
        final res = await _userLocalDataSource.getConversationHistory(
          limit: limit,
          lastInteractedAt: lastInteractedAt,
        );
        return res;
      }
      final users = await _userRemoteDataSource.getConversationHistory(
        limit: limit,
        lastInteractedAt: lastInteractedAt,
      );
      await _userLocalDataSource.saveConversationsHistory(users.data);
      return users;
    }, context: 'getConversationHistory');
  }

  @override
  Either<Failure, Stream<List<Conversation>>> getConversationHistoryStream() {
    return handleSyncException(
      () {
        final stream = _userLocalDataSource.getConversationHistoryStream();
        return right(stream);
      },
      context: 'getConversationHistoryStream',
      defaultValue: left(Failure('Failed to get conversation history stream')),
    );
  }

  @override
  Future<Either<Failure, ApiResponse<User, UserPagination>>> searchUser(
    String query, {
    required int limit,
    required int offset,
  }) async {
    return await handleException(() async {
      if (!_networkInfo.checkConnection()) {
        final res = await _userLocalDataSource.searchUser(
          query,
          limit: limit,
          offset: offset,
        );
        if (res.data.isEmpty) {
          throw const ServerException('No internet connection');
        }
        return res;
      }
      final res = await _userRemoteDataSource.searchUser(
        query,
        limit: limit,
        offset: offset,
      );
      return res;
    }, context: 'searchUser');
  }

  @override
  Future<Either<Failure, User>> updateProfileImage(File file) async {
    return await handleException(() async {
      if (!_networkInfo.checkConnection()) {
        throw const ServerException('No internet connection');
      }
      final res = await _userRemoteDataSource.updateProfileImage(file);
      await _userLocalDataSource.saveUser(res);
      return res;
    }, context: 'updateProfileImage');
  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    return await handleException(() async {
      if (!_networkInfo.checkConnection()) {
        throw const ServerException('No internet connection');
      }
      final res = await _userRemoteDataSource.updateUser(
        UserModel.fromUser(user),
      );
      await _userLocalDataSource.updateUser(res);
      return res;
    }, context: 'updateUser');
  }

  @override
  Future<Either<Failure, User>> getCurretUser({required bool local}) async {
    return await handleException(() async {
      if (local) {
        final res = await _userLocalDataSource.getCurrentUser();
        return res;
      }
      final res = await _userRemoteDataSource.getCurrentUser();
      await _userLocalDataSource.saveUser(res);
      return res;
    }, context: 'getCurretUser');
  }
}
