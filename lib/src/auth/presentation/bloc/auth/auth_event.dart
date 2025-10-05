part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class EmailLogin extends AuthEvent {
  final String email;
  final String password;

  EmailLogin(this.email, this.password);
}

final class EmailSignUp extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String phoneNumber;

  EmailSignUp(
    this.email,
    this.password, {
    required this.name,
    required this.phoneNumber,
  });
}

final class VerifyEmail extends AuthEvent {
  final String email;

  VerifyEmail(this.email);
}

final class ResetPassword extends AuthEvent {
  final String email;

  ResetPassword(this.email);
}

final class Logout extends AuthEvent {}

final class UserLoggedIn extends AuthEvent {}
