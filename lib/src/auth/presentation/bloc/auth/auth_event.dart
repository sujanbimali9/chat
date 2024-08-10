part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class CheckAuthStatus extends AuthEvent {}

final class EmailLogin extends AuthEvent {
  final String email;
  final String password;

  EmailLogin(this.email, this.password);
}

final class GoogleLogin extends AuthEvent {}

final class FacebookLogin extends AuthEvent {}

final class EmailSignUp extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String username;
  final String phoneNumber;

  EmailSignUp(
    this.email,
    this.password, {
    required this.fullName,
    required this.username,
    required this.phoneNumber,
  });
}

final class VerifyEmail extends AuthEvent {
  final String email;

  VerifyEmail(this.email);
}

final class ResendEmailVerification extends AuthEvent {
  final String email;

  ResendEmailVerification(this.email);
}

final class ResetPassword extends AuthEvent {
  final String email;

  ResetPassword(this.email);
}

final class ResendResetEmail extends AuthEvent {
  final String email;

  ResendResetEmail(this.email);
}

final class Logout extends AuthEvent {}
