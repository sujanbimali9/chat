import 'dart:io';

import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/exception/server_exception.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/home/data/datasource/home_remote_data_source.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/src/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class HomeRepositoryImp implements HomeRepository {
  final HomeRemoteDataSource _homeRemoteDataSource;

  HomeRepositoryImp(HomeRemoteDataSource homeRemoteDataSource)
      : _homeRemoteDataSource = homeRemoteDataSource;
  @override
  Future<Either<Failure, UserModel>> createUser() async {
    try {
      final res = await _homeRemoteDataSource.createUser();
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
      final res =
          await _homeRemoteDataSource.getAllUser(limit: limit, offset: offset);
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
      final res = await _homeRemoteDataSource.searchUser(query);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfileImage(File file) async {
    try {
      final res = await _homeRemoteDataSource.updateProfileImage(file);
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
      final res =
          await _homeRemoteDataSource.updateUser(UserModel.fromUser(user));
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
      final res = await _homeRemoteDataSource.getCurrentUser();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Either<Failure, Stream<Map<String, Chat>>> getLastChat(List<String> chatIds) {
    try {
      final res = _homeRemoteDataSource.getLastChat(chatIds);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
