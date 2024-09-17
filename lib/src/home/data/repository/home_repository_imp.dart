import 'dart:io';

import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/exception/server_exception.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/home/data/datasource/home_local_data_source.dart';
import 'package:chat/src/home/data/datasource/home_remote_data_source.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/src/home/domain/repository/home_repository.dart';
import 'package:chat/utils/helper/network_info.dart';
import 'package:fpdart/fpdart.dart';

class HomeRepositoryImp implements HomeRepository {
  final HomeRemoteDataSource _homeRemoteDataSource;
  final NetworkInfo _networkInfo;
  final HomeLocalDataSource _homeLocalDataSource;

  HomeRepositoryImp(
    HomeRemoteDataSource homeRemoteDataSource,
    NetworkInfo networkInfo,
    HomeLocalDataSource homeLocalDataSource,
  )   : _homeRemoteDataSource = homeRemoteDataSource,
        _networkInfo = networkInfo,
        _homeLocalDataSource = homeLocalDataSource;

  @override
  Future<Either<Failure, UserModel>> createUser() async {
    try {
      final res = await _homeRemoteDataSource.createUser();
      await _homeLocalDataSource.createUser(res);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      final res = await _homeRemoteDataSource.deleteUser(id);
      await _homeLocalDataSource.deleteUser(id);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, UserModel>>> getAllUser(
      {int? limit, int? offset}) async {
    try {
      if (!_networkInfo.checkConnection()) {
        final res =
            await _homeLocalDataSource.getAllUser(limit: limit, offset: offset);
        if (res.isNotEmpty) {
          return right(res);
        }
      }

      final res =
          await _homeRemoteDataSource.getAllUser(limit: limit, offset: offset);
      await _homeLocalDataSource.saveUsers(res.values.toList());
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserById(String id) async {
    try {
      final res = await _homeRemoteDataSource.getUserById(id);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, UserModel>>> searchUser(
      String query) async {
    try {
      if (!_networkInfo.checkConnection()) {
        final res = await _homeLocalDataSource.searchUser(query);
        if (res.isNotEmpty) {
          return right(res);
        }
        return left(Failure('No internet connection'));
      }
      final res = await _homeRemoteDataSource.searchUser(query);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfileImage(File file) async {
    try {
      if (!_networkInfo.checkConnection()) {
        return left(Failure('No internet connection'));
      }
      final res = await _homeRemoteDataSource.updateProfileImage(file);
      await _homeLocalDataSource.updateUser(res.toJson());
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOnlineStatus(bool show) async {
    try {
      if (!_networkInfo.checkConnection()) {
        return left(Failure('No internet connection'));
      }
      final res = await _homeRemoteDataSource.updateOnlineStatus(show);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateUser(User user) async {
    try {
      if (!_networkInfo.checkConnection()) {
        return left(Failure('No internet connection'));
      }
      final res =
          await _homeRemoteDataSource.updateUser(UserModel.fromUser(user));
      await _homeLocalDataSource.updateUser(res.toJson());
      return right(res);
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
        final res = await _homeLocalDataSource.getCurrentUser();
        return right(res);
      }

      final res = await _homeRemoteDataSource.getCurrentUser();
      await _homeLocalDataSource.saveCurrentUser(res);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, Chat>>> getLastChat() async {
    try {
      if (!_networkInfo.checkConnection()) {
        final res = await _homeLocalDataSource.getLastChat();
        if (res.isNotEmpty) {
          return right(res);
        }
        return left(Failure('No internet connection'));
      }
      final res = await _homeRemoteDataSource.getLastChat();
      await _homeLocalDataSource.savelastChats(res.values.toList());
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
