import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/auth/domain/usecases/email_and_password_login.dart';

import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/auth/domain/usecases/reset_password.dart';
import 'package:chat/src/auth/domain/usecases/signup.dart';
import 'package:chat/src/auth/domain/usecases/user_logged_in.dart';
import 'package:chat/src/auth/domain/usecases/verify_email.dart';
import 'package:flutter/cupertino.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _signUpWithEmailUseCase;
  final LogOutUseCase _signOutUseCase;
  final EmailAndPasswordLoginUseCase _emailAndPasswordLoginUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  final UserLoggedInUseCase _userLoggedInUseCase;

  AuthBloc(
    SignUpUseCase signUpWithEmailUseCase,
    LogOutUseCase signOutUseCase,
    EmailAndPasswordLoginUseCase emailAndPasswordLoginUseCase,
    ResetPasswordUseCase resetPasswordUseCase,
    EmailVerifiedUseCase verifyEmailUseCase,
    UserLoggedInUseCase userLoggedInUseCase,
  ) : _signUpWithEmailUseCase = signUpWithEmailUseCase,
      _signOutUseCase = signOutUseCase,
      _emailAndPasswordLoginUseCase = emailAndPasswordLoginUseCase,
      _resetPasswordUseCase = resetPasswordUseCase,
      _userLoggedInUseCase = userLoggedInUseCase,
      super(AuthInitial()) {
    on<EmailLogin>(_emailLogin);
    on<EmailSignUp>(_emailSignUp);
    on<ResetPassword>(_resetPassword);

    on<Logout>(_logout);
    on<UserLoggedIn>(_userLoggedIn);
    add(UserLoggedIn());
  }

  FutureOr<void> _logout(Logout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _signOutUseCase(NoParams());
    result.fold((failure) => emit(AuthError(failure.message)), (success) {
      {
        emit(AuthInitial());
      }
    });
  }

  FutureOr<void> _resetPassword(
    ResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _resetPasswordUseCase(event.email);
    result.fold((failure) => emit(AuthError(failure.message)), (success) {
      {
        emit(AuthResetEmailSent(event.email));
      }
    });
  }

  FutureOr<void> _emailSignUp(
    EmailSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _signUpWithEmailUseCase(
      SingUpParms(
        email: event.email,
        password: event.password,
        name: event.name,
        phoneNumber: event.phoneNumber,
      ),
    );
    result.fold((failure) => emit(AuthError(failure.message)), (success) {
      {
        emit(AuthLoggedIn(success));
      }
    });
  }

  FutureOr<void> _emailLogin(EmailLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _emailAndPasswordLoginUseCase(
      LoginWithEmailParms(email: event.email, password: event.password),
    );
    result.fold((failure) => emit(AuthError(failure.message)), (success) {
      {
        emit(AuthLoggedIn(success));
      }
    });
  }

  FutureOr<void> _userLoggedIn(
    UserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _userLoggedInUseCase(NoParams());
    result.fold((failure) => emit(AuthError(failure.message)), (success) {
      if (success != null) {
        emit(AuthLoggedIn(success));
      } else {
        emit(AuthLoggedOut());
      }
    });
  }
}
