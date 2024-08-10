import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat/src/auth/domain/usecases/current_user.dart';
import 'package:chat/src/auth/domain/usecases/email_and_password_login.dart';
import 'package:chat/src/auth/domain/usecases/facebook_login.dart';
import 'package:chat/src/auth/domain/usecases/forget_password.dart';
import 'package:chat/src/auth/domain/usecases/gmail_login.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/auth/domain/usecases/resend_reset_email.dart';
import 'package:chat/src/auth/domain/usecases/resend_verify_email.dart';
import 'package:chat/src/auth/domain/usecases/signup.dart';
import 'package:chat/src/auth/domain/usecases/user_logged_in.dart';
import 'package:chat/src/auth/domain/usecases/verify_email.dart';
import 'package:flutter/cupertino.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithFacebookUseCase _loginWithFacebookUseCase;
  final LoginWithGmailUseCase _loginWithGmailUseCase;
  final SignUpUseCase _signUpWithEmailUseCase;
  final LogOutUseCase _signOutUseCase;
  final EmailAndPasswordLoginUseCase _emailAndPasswordLoginUseCase;
  final ForgetPasswordUseCase _forgetPasswordUseCase;
  final ResendVerifyEmailUseCase _resendVerifyEmailUseCase;
  final ResendResetEmailUseCase _resendResetEmailUseCase;
  final EmailVerifiedUseCase _verifyEmailUseCase;
  // final UserLoggedInUseCase _userLoggedInUseCase;
  // final CurrentUserUseCase _currentUserUseCase;

  AuthBloc(
    LoginWithFacebookUseCase loginWithFacebookUseCase,
    LoginWithGmailUseCase loginWithGmailUseCase,
    SignUpUseCase signUpWithEmailUseCase,
    LogOutUseCase signOutUseCase,
    EmailAndPasswordLoginUseCase emailAndPasswordLoginUseCase,
    ForgetPasswordUseCase forgetPasswordUseCase,
    ResendVerifyEmailUseCase resendVerifyEmailUseCase,
    ResendResetEmailUseCase resendResetEmailUseCase,
    EmailVerifiedUseCase verifyEmailUseCase,
    UserLoggedInUseCase userLoggedInUseCase,
    CurrentUserUseCase currentUserUseCase,
  )   : _loginWithFacebookUseCase = loginWithFacebookUseCase,
        _loginWithGmailUseCase = loginWithGmailUseCase,
        _signUpWithEmailUseCase = signUpWithEmailUseCase,
        _signOutUseCase = signOutUseCase,
        _emailAndPasswordLoginUseCase = emailAndPasswordLoginUseCase,
        _forgetPasswordUseCase = forgetPasswordUseCase,
        _resendVerifyEmailUseCase = resendVerifyEmailUseCase,
        _resendResetEmailUseCase = resendResetEmailUseCase,
        _verifyEmailUseCase = verifyEmailUseCase,
        // _userLoggedIn = userLoggedIn,
        // _currentUser = currentUser,
        super(userLoggedInUseCase()
            ? verifyEmailUseCase()
                ? const AuthLoggedIn()
                : AuthEmailUnVerified(currentUserUseCase()?.email ?? '')
            : AuthInitial()) {
    on<FacebookLogin>(_facebookLogin);
    on<GoogleLogin>(_googleLogin);
    on<EmailLogin>(_emailLogin);
    on<EmailSignUp>(_emailSignUp);
    on<ResetPassword>(_resetPassword);
    on<ResendEmailVerification>(_resendEmailVerification);
    on<ResendResetEmail>(_resendResetEmail);
    on<VerifyEmail>(_verifyEmail);
    on<Logout>(_logout);
  }

  FutureOr<void> _logout(Logout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    log('Logout');
    final result = await _signOutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authResponse) {
        {
          emit(AuthInitial());
        }
      },
    );
  }

  FutureOr<void> _verifyEmail(VerifyEmail event, Emitter<AuthState> emit) {
    final result = _verifyEmailUseCase();
    if (result) {
      emit(AuthEmailVerified(event.email));
    } else {
      emit(const AuthEmailVerificationError("Email not verified"));
    }
  }

  FutureOr<void> _resendResetEmail(
      ResendResetEmail event, Emitter<AuthState> emit) async {
    final result = await _resendResetEmailUseCase(event.email);
    result.fold(
      (failure) => emit(AuthPasswordResetError(failure.message)),
      (authResponse) {
        {
          emit(AuthPasswordResetResend(event.email));
        }
      },
    );
  }

  FutureOr<void> _resendEmailVerification(
      ResendEmailVerification event, Emitter<AuthState> emit) async {
    final result = await _resendVerifyEmailUseCase(event.email);
    result.fold(
      (failure) => emit(AuthEmailVerificationError(failure.message)),
      (authResponse) {
        {
          emit(AuthEmailResendVerification(event.email));
        }
      },
    );
  }

  FutureOr<void> _resetPassword(
      ResetPassword event, Emitter<AuthState> emit) async {
    final result =
        await _forgetPasswordUseCase(ForgetPasswordParms(email: event.email));
    result.fold(
      (failure) => emit(AuthPasswordResetError(failure.message)),
      (authResponse) {
        {
          emit(AuthPasswordResetVerify(event.email));
        }
      },
    );
  }

  FutureOr<void> _emailSignUp(
      EmailSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _signUpWithEmailUseCase(SingUpParms(
      email: event.email,
      password: event.password,
      fullName: event.fullName,
      username: event.username,
      phoneNumber: event.phoneNumber,
    ));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authResponse) {
        {
          emit(AuthEmailUnVerified(event.email));
        }
      },
    );
  }

  FutureOr<void> _emailLogin(EmailLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _emailAndPasswordLoginUseCase(
        LoginWithEmailParms(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authResponse) {
        {
          emit(const AuthLoggedIn(mode: LoginMode.email));
        }
      },
    );
  }

  FutureOr<void> _googleLogin(
      GoogleLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _loginWithGmailUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authResponse) {
        {
          emit(const AuthLoggedIn(mode: LoginMode.google));
        }
      },
    );
  }

  FutureOr<void> _facebookLogin(
      FacebookLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _loginWithFacebookUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authResponse) {
        {
          emit(const AuthLoggedIn(mode: LoginMode.facebook));
        }
      },
    );
  }
}

LoginMode getLoginMode(String mode) {
  switch (mode) {
    case 'google':
      return LoginMode.google;
    case 'facebook':
      return LoginMode.facebook;
    default:
      return LoginMode.email;
  }
}
