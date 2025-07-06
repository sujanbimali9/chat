import 'dart:developer';
import 'dart:io';

import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/home/data/datasource/user_local_data_source.dart';
import 'package:chat/src/home/data/datasource/user_remote_data_source.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:chat/utils/helper/network_info.dart';
import 'package:fpdart/fpdart.dart';

class UserRepositoryImp implements UserRepository {
  final UserRemoteDataSource _userRemoteDataSource;
  final UserLocalDataSource _userLocalDataSource;
  final NetworkInfo _networkInfo;

  UserRepositoryImp(
    this._userRemoteDataSource,
    this._userLocalDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, ApiResponse<User>>> getAllUsers(
      {required int limit, required int offset}) async {
    try {
      final users =
          await _userRemoteDataSource.getAllUsers(limit: limit, offset: offset);

      await _userLocalDataSource.saveUsers(users.data);
      return right(users.map(User.fromUserModel));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<User>>> getInteractedUser(
      {required int limit, required int offset}) async {
    try {
      final users = await _userRemoteDataSource.getInteractedUser(
        limit: limit,
        offset: offset,
      );
      return right(users.map(User.fromUserModel));
    } on ServerException catch (e) {
      log('GetInteractedUser error: $e');
      return left(Failure(e.message));
    } catch (e) {
      log('GetInteractedUser error: $e');
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<User>>> searchUser(
    String query, {
    required int limit,
    required int offset,
  }) async {
    try {
      if (!_networkInfo.checkConnection()) {
        final res = await _userLocalDataSource.searchUser(query,
            limit: limit, offset: offset);
        if (res.data.isNotEmpty) {
          return right(res.map((e) => User.fromUserModel(e)));
        }
        return left(Failure('No internet connection'));
      }
      final res = await _userRemoteDataSource.searchUser(query,
          limit: limit, offset: offset);
      return right(
        res.map(User.fromUserModel),
      );
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfileImage(File file) async {
    try {
      if (!_networkInfo.checkConnection()) {
        return left(Failure('No internet connection'));
      }
      final res = await _userRemoteDataSource.updateProfileImage(file);
      await _userLocalDataSource.updateUser(res);
      return right(User.fromUserModel(res));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    try {
      if (!_networkInfo.checkConnection()) {
        return left(Failure('No internet connection'));
      }
      final res =
          await _userRemoteDataSource.updateUser(UserModel.fromUser(user));
      await _userLocalDataSource.updateUser(res);
      return right(User.fromUserModel(res));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurretUser() async {
    try {
      if (!_networkInfo.checkConnection()) {
        final res = await _userLocalDataSource.getCurrentUser();
        return right(User.fromUserModel(res));
      }

      final res = await _userRemoteDataSource.getCurrentUser();
      await _userLocalDataSource.saveUser(res);
      return right(User.fromUserModel(res));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Either<Failure, Stream<List<User>>> getUsersStream() {
    try {
      final res = _userLocalDataSource.getUsersStream();
      return right(res.map((e) => e.map(User.fromUserModel).toList()));
    } on ServerException catch (e) {
      log('GetUsersStream error: $e');
      return left(Failure(e.message));
    } catch (e) {
      log('GetUsersStream error: $e');
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<User>>> getAllUserLocal(
      {required int limit, required int offset}) async {
    try {
      final res = await _userLocalDataSource.getAllUser(
        limit: limit,
        offset: offset,
      );
      return right(res.map(User.fromUserModel));
    } on ServerException catch (e) {
      log('GetAllUserLocal error: $e');
      return left(Failure(e.message));
    } catch (e) {
      log('GetAllUserLocal error: $e');
      return left(Failure(e.toString()));
    }
  }
}
