import 'dart:developer';

import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/auth/data/datasource/auth_local_datasource.dart';
import 'package:chat/src/auth/data/datasource/auth_remote_datasource.dart';
import 'package:chat/src/auth/data/model/auth_result.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  Future<Either<Failure, T>> _handleException<T>(
    Future<T> Function() fn, {
    String context = '',
  }) async {
    try {
      final result = await fn();
      return right(result);
    } on ServerException catch (e) {
      log('Server Exception: ${e.message}', name: 'AuthRepository.$context');
      return left(Failure(e.message));
    } on CacheException catch (e) {
      log('Cache Exception: ${e.message}', name: 'AuthRepository.$context');
      return left(Failure(e.message));
    } catch (e) {
      log('Unexpected Exception: $e', name: 'AuthRepository.$context');
      return left(Failure(e.toString()));
    }
  }

  AuthRepositoryImp(this._authLocalDataSource, this._authRemoteDataSource);
  @override
  Future<Either<Failure, AuthResponse>> forgotPassword(String email) async {
    return await _handleException(() async {
      final result = await _authRemoteDataSource.forgotPassword(email);
      return AuthResponse(authResult: result, errorMessage: null);
    }, context: 'forgotPassword');
  }

  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _handleException(() async {
      final result = await _authRemoteDataSource.loginWithEmailAndPassword(
        email,
        password,
      );
      return User.fromUserModel(result);
    }, context: 'loginWithEmailAndPassword');
  }

  @override
  Future<Either<Failure, User>> loginWithFacebook() async {
    return await _handleException(() async {
      final result = await _authRemoteDataSource.loginWithFacebook();
      return User.fromUserModel(result);
    }, context: 'loginWithFacebook');
  }

  @override
  Future<Either<Failure, User>> loginWithGmail() async {
    return await _handleException(() async {
      final result = await _authRemoteDataSource.loginWithGmail();
      return User.fromUserModel(result);
    }, context: 'loginWithGmail');
  }

  @override
  Future<Either<Failure, AuthResponse>> logout() async {
    return await _handleException(() async {
      final result = await _authRemoteDataSource.logout();
      return AuthResponse(authResult: result, errorMessage: null);
    }, context: 'logout');
  }

  @override
  Future<Either<Failure, User>> register(
    String email,
    String password, {
    required String name,
    required String phoneNumber,
  }) async {
    return await _handleException(() async {
      final result = await _authRemoteDataSource.register(
        email,
        password,
        name: name,
        phoneNumber: phoneNumber,
      );
      return User.fromUserModel(result);
    }, context: 'register');
  }

  @override
  Future<Either<Failure, AuthResponse>> resetPassword(String email) async {
    return await _handleException(() async {
      final result = await _authRemoteDataSource.resetPassword(email);
      return AuthResponse(authResult: result, errorMessage: null);
    }, context: 'resetPassword');
  }

  @override
  bool emailVerified() {
    return _authRemoteDataSource.emailVerified;
  }

  @override
  Future<Either<Failure, User?>> userLoggedIn() async {
    return await _handleException(() async {
      final userId = _authRemoteDataSource.isUserLoggedIn;
      if (userId == null) {
        return null;
      }
      final user = await _authLocalDataSource.getCachedUser(userId);
      if (user == null) {
        return null;
      }
      return User.fromUserModel(user);
    }, context: 'userLoggedIn');
  }
}
