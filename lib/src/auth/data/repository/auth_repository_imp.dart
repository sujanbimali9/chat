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

  AuthRepositoryImp(this._authLocalDataSource, this._authRemoteDataSource);
  @override
  Future<Either<Failure, AuthResponse>> forgotPassword(String email) async {
    try {
      final result = await _authRemoteDataSource.forgotPassword(email);
      return right(AuthResponse(authResult: result, errorMessage: null));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await _authRemoteDataSource.loginWithEmailAndPassword(
          email, password);
      return right(User.fromUserModel(result));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithFacebook() async {
    try {
      final result = await _authRemoteDataSource.loginWithFacebook();
      return right(User.fromUserModel(result));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithGmail() async {
    try {
      final result = await _authRemoteDataSource.loginWithGmail();

      return right(User.fromUserModel(result));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> logout() async {
    try {
      final result = await _authRemoteDataSource.logout();
      return right(AuthResponse(authResult: result, errorMessage: null));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(
    String email,
    String password, {
    required String name,
    required String phoneNumber,
  }) async {
    try {
      final result = await _authRemoteDataSource.register(
        email,
        password,
        name: name,
        phoneNumber: phoneNumber,
      );

      return right(User.fromUserModel(result));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> resetPassword(String email) async {
    try {
      final result = await _authRemoteDataSource.resetPassword(email);
      return right(AuthResponse(authResult: result, errorMessage: null));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  bool emailVerified() {
    return _authRemoteDataSource.emailVerified;
  }

  @override
  Future<Either<Failure, User?>> userLoggedIn() async {
    try {
      final userId = _authRemoteDataSource.isUserLoggedIn;
      if (userId == null) {
        return right(null);
      }
      final user = await _authLocalDataSource.getCachedUser(userId);
      if (user == null) {
        return right(null);
      }
      return right(User.fromUserModel(user));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
