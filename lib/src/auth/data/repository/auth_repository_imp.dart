import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/mixins/exception_handler_mixin.dart';
import 'package:chat/src/auth/data/datasource/auth_local_datasource.dart';
import 'package:chat/src/auth/data/datasource/auth_remote_datasource.dart';
import 'package:chat/src/auth/data/model/auth_result.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImp with ExceptionHandlerMixin implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepositoryImp(this._authLocalDataSource, this._authRemoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await handleException(() async {
      final result = await _authRemoteDataSource.loginWithEmailAndPassword(
        email,
        password,
      );
      return result;
    }, context: 'loginWithEmailAndPassword');
  }

  @override
  Future<Either<Failure, AuthResponse>> logout() async {
    return await handleException(() async {
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
    return await handleException(() async {
      final result = await _authRemoteDataSource.register(
        email,
        password,
        name: name,
        phoneNumber: phoneNumber,
      );
      return result;
    }, context: 'register');
  }

  @override
  Future<Either<Failure, AuthResponse>> resetPassword(String email) async {
    return await handleException(() async {
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
    return await handleException(() async {
      final userId = _authRemoteDataSource.isUserLoggedIn;
      if (userId == null) {
        return null;
      }
      final user = await _authLocalDataSource.getCachedUser(userId);
      if (user == null) {
        return null;
      }
      return user;
    }, context: 'userLoggedIn');
  }
}
