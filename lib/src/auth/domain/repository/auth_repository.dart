import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/auth/data/model/auth_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AuthResponse>> register(
    String email,
    String password, {
    required String fullName,
    required String username,
    required String phoneNumber,
  });
  Future<Either<Failure, AuthResponse>> logout();
  Future<Either<Failure, AuthResponse>> forgotPassword(String email);
  Future<Either<Failure, AuthResponse>> resendResetEmail(String email);
  Future<Either<Failure, AuthResponse>> loginWithGmail();
  Future<Either<Failure, AuthResponse>> loginWithFacebook();
  Future<Either<Failure, AuthResponse>> loginWithEmailAndPassword(
      String email, String password);
  Future<Either<Failure, AuthResponse>> resendEmailVerification(String email);
  bool emailVerified();
  bool isUserLoggedIn();
  supabase.User? currentUser();
}
