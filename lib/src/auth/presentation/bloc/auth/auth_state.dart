part of 'auth_bloc.dart';

enum LoginMode {
  google,
  email,
  facebook;

  bool get isGoogle => this == LoginMode.google;
  bool get isEmail => this == LoginMode.email;
  bool get isFacebook => this == LoginMode.facebook;
}

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

final class AuthLoggedIn extends AuthState {
  final User user;

  const AuthLoggedIn(this.user);
}

final class AuthLoggedOut extends AuthState {}

final class AuthResetEmailSent extends AuthState {
  final String email;

  const AuthResetEmailSent(this.email);
}
