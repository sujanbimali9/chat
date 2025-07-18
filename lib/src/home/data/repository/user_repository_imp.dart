import 'dart:developer';
import 'dart:io';

import 'package:fpdart/fpdart.dart';

import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/home/data/datasource/user_local_data_source.dart';
import 'package:chat/src/home/data/datasource/user_remote_data_source.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:chat/utils/helper/network_info.dart';

class UserRepositoryImp implements UserRepository {
  final UserRemoteDataSource _userRemoteDataSource;
  final UserLocalDataSource _userLocalDataSource;
  final NetworkInfo _networkInfo;

  UserRepositoryImp(
    this._userRemoteDataSource,
    this._userLocalDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, T>> _handleException<T>(
    Future<T> Function() fn, {
    String context = '',
  }) async {
    try {
      final result = await fn();
      return right(result);
    } on ServerException catch (e) {
      log('Server Exception: ${e.message}', name: 'UserRepository.$context');
      return left(Failure(e.message));
    } on CacheException catch (e) {
      log('Cache Exception: ${e.message}', name: 'UserRepository.$context');
      return left(Failure(e.message));
    } catch (e) {
      log('Unexpected Exception: $e', name: 'UserRepository.$context');
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<User, UserPagination>>> getAllUsers({
    required int limit,
    required int offset,
  }) async {
    return await _handleException(() async {
      final users = await _userRemoteDataSource.getAllUsers(
        limit: limit,
        offset: offset,
      );

      await _userLocalDataSource.saveUsers(users.data);
      return users.map(User.fromUserModel);
    }, context: 'getAllUsers');
  }

  @override
  Future<Either<Failure, ApiResponse<({User user, Chat chat}), UserPagination>>>
  getInteractedUser({required int limit, required int offset}) async {
    return await _handleException(() async {
      final users = await _userRemoteDataSource.getInteractedUser(
        limit: limit,
        offset: offset,
      );
      await _userLocalDataSource.saveInteractedUsers(users.data);
      return users.map(
        (e) => (
          user: User.fromUserModel(e.user),
          chat: Chat.fromChatModel(e.chat),
        ),
      );
    });
  }

  @override
  Either<Failure, Stream<List<({Chat chat, User user})>>>
  getInteractedUserStream() {
    try {
      final stream = _userLocalDataSource.getInteractedUserStream();
      return right(
        stream.map((data) {
          return data
              .map(
                (e) => (
                  chat: Chat.fromChatModel(e.chat),
                  user: User.fromUserModel(e.user),
                ),
              )
              .toList();
        }),
      );
    } on ServerException catch (e) {
      log('GetInteractedUserStream error: $e');
      return left(Failure(e.message));
    } catch (e) {
      log('GetInteractedUserStream error: $e');
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<User, UserPagination>>> searchUser(
    String query, {
    required int limit,
    required int offset,
  }) async {
    return await _handleException(() async {
      if (!_networkInfo.checkConnection()) {
        final res = await _userLocalDataSource.searchUser(
          query,
          limit: limit,
          offset: offset,
        );
        if (res.data.isEmpty) {
          throw const ServerException('No internet connection');
        }
        return res.map((e) => User.fromUserModel(e));
      }
      final res = await _userRemoteDataSource.searchUser(
        query,
        limit: limit,
        offset: offset,
      );
      return res.map(User.fromUserModel);
    }, context: 'searchUser');
  }

  @override
  Future<Either<Failure, User>> updateProfileImage(File file) async {
    return await _handleException(() async {
      if (!_networkInfo.checkConnection()) {
        throw const ServerException('No internet connection');
      }
      final res = await _userRemoteDataSource.updateProfileImage(file);
      await _userLocalDataSource.saveUser(res);
      return User.fromUserModel(res);
    }, context: 'updateProfileImage');
  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    return await _handleException(() async {
      if (!_networkInfo.checkConnection()) {
        throw const ServerException('No internet connection');
      }
      final res = await _userRemoteDataSource.updateUser(
        UserModel.fromUser(user),
      );
      await _userLocalDataSource.updateUser(res);
      return User.fromUserModel(res);
    }, context: 'updateUser');
  }

  @override
  Future<Either<Failure, User>> getCurretUser() async {
    return await _handleException(() async {
      if (!_networkInfo.checkConnection()) {
        final res = await _userLocalDataSource.getCurrentUser();
        return User.fromUserModel(res);
      }
      final res = await _userRemoteDataSource.getCurrentUser();
      await _userLocalDataSource.saveUser(res);
      return User.fromUserModel(res);
    }, context: 'getCurretUser');
  }

  @override
  Future<Either<Failure, ApiResponse<User, UserPagination>>> getAllUserLocal({
    required int limit,
    required int offset,
  }) async {
    return await _handleException(() async {
      final res = await _userLocalDataSource.getAllUser(
        limit: limit,
        offset: offset,
      );
      return res.map(User.fromUserModel);
    }, context: 'getAllUserLocal');
  }
}
