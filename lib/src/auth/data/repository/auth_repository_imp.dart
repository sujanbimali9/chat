import 'package:chat/core/exception/server_exception.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/auth/data/datasource/auth_remote_datasource.dart';
import 'package:chat/src/auth/data/model/auth_result.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImp(AuthRemoteDataSource authRemoteDataSource)
      : _authRemoteDataSource = authRemoteDataSource;
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
  Future<Either<Failure, AuthResponse>> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await _authRemoteDataSource.loginWithEmailAndPassword(
          email, password);
      return right(AuthResponse(authResult: result, errorMessage: null));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> loginWithFacebook() async {
    try {
      final result = await _authRemoteDataSource.loginWithFacebook();
      return right(AuthResponse(authResult: result, errorMessage: null));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> loginWithGmail() async {
    try {
      final result = await _authRemoteDataSource.loginWithGmail();

      return right(AuthResponse(authResult: result, errorMessage: null));
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
  Future<Either<Failure, AuthResponse>> register(
    String email,
    String password, {
    required String fullName,
    required String username,
    required String phoneNumber,
  }) async {
    try {
      final result = await _authRemoteDataSource.register(email, password,
          fullName: fullName, username: username, phoneNumber: phoneNumber);

      return right(AuthResponse(authResult: result, errorMessage: null));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> resendEmailVerification(
      String email) async {
    try {
      final result = await _authRemoteDataSource.resendResetEmail(email);
      return right(AuthResponse(authResult: result, errorMessage: null));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> resendResetEmail(String email) async {
    try {
      final result = await _authRemoteDataSource.resendResetEmail(email);
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
  bool isUserLoggedIn() {
    return _authRemoteDataSource.isUserLoggedIn;
  }

  @override
  supabase.User? currentUser() {
    return _authRemoteDataSource.currentUser;
  }
}
