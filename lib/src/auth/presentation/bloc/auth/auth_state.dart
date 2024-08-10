part of 'auth_bloc.dart';

enum LoginMode { google, email, facebook }

extension LoginModeExtension on LoginMode {
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
  final LoginMode? mode;

  const AuthLoggedIn({this.mode});
}

final class AuthLoggedOut extends AuthState {}

final class AuthEmailResendVerification extends AuthState {
  final String email;

  const AuthEmailResendVerification(this.email);
}

final class AuthEmailVerified extends AuthState {
  final String email;

  const AuthEmailVerified(this.email);
}

final class AuthEmailUnVerified extends AuthState {
  final String email;

  const AuthEmailUnVerified(
    this.email,
  );
}

final class AuthEmailVerificationError extends AuthState {
  final String message;

  const AuthEmailVerificationError(this.message);
}

final class AuthPasswordResetError extends AuthState {
  final String message;

  const AuthPasswordResetError(this.message);
}

final class AuthPasswordResetVerify extends AuthState {
  final String email;

  const AuthPasswordResetVerify(this.email);
}

final class AuthPasswordResetResend extends AuthState {
  final String email;

  const AuthPasswordResetResend(this.email);
}
