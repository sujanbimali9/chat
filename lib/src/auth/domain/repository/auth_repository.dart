import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/auth/data/model/auth_result.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> register(
    String email,
    String password, {
    required String name,
    required String phoneNumber,
  });
  Future<Either<Failure, AuthResponse>> logout();
  Future<Either<Failure, AuthResponse>> resetPassword(String email);
  Future<Either<Failure, User>> loginWithEmailAndPassword(
    String email,
    String password,
  );
  bool emailVerified();
  Future<Either<Failure, User?>> userLoggedIn();
}
