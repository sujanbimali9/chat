import 'dart:developer';
import 'dart:io';

import 'package:chat/core/exception/server_exception.dart';
import 'package:chat/src/auth/data/model/auth_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@immutable
abstract interface class AuthRemoteDataSource {
  Future<AuthResult> register(
    String email,
    String password, {
    required String fullName,
    required String username,
    required String phoneNumber,
  });
  Future<AuthResult> logout();
  Future<AuthResult> forgotPassword(String email);
  Future<AuthResult> resendResetEmail(String email);
  Future<AuthResult> loginWithGmail();
  Future<AuthResult> loginWithFacebook();
  Future<AuthResult> loginWithEmailAndPassword(String email, String password);
  Future<AuthResult> resendEmailVerification(String email);
  bool get isUserLoggedIn;
  bool get emailVerified;
  User? get currentUser;
}

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSourceImp(SupabaseClient supabaseClient)
      : _supabaseClient = supabaseClient;

  @override
  Future<AuthResult> forgotPassword(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
      return AuthResult.success;
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResult> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      await _supabaseClient.auth
          .signInWithPassword(email: email, password: password);

      return AuthResult.success;
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResult> loginWithFacebook() async {
    try {
      if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
        final res = await _supabaseClient.auth.signInWithOAuth(
          OAuthProvider.facebook,
        );
        if (res || _supabaseClient.auth.currentUser != null) {
          return AuthResult.success;
        }
        throw const AuthException('login failed try again later');
      }
      LoginResult result = await FacebookAuth.instance
          .login(permissions: ['email', 'public_profile']);

      if (result.status == LoginStatus.cancelled) {
        return AuthResult.aborted;
      } else if (result.status == LoginStatus.failed) {
        throw const AuthException('login failed try again later');
      }
      await _supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.facebook,
        idToken: result.accessToken!.tokenString,
      );
      final userData = await FacebookAuth.instance.getUserData();
      await _supabaseClient.auth.updateUser(
        UserAttributes(
          email: userData['email'],
          phone: userData['phone'],
          data: {
            'profile': userData['picture']['data']['url'],
            'full_name': userData['name'],
          },
        ),
      );
      return AuthResult.success;
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResult> loginWithGmail() async {
    try {
      final GoogleSignInAccount? signInAccount = await GoogleSignIn().signIn();
      if (signInAccount == null) {
        return AuthResult.aborted;
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await signInAccount.authentication;
      final idToken = googleSignInAuthentication.idToken;
      final accessToken = googleSignInAuthentication.accessToken;
      if (idToken == null || accessToken == null) {
        throw const AuthException('login failed try again later');
      }
      await _supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      await _supabaseClient.auth.updateUser(
        UserAttributes(
          email: signInAccount.email,
          data: {
            'profile': signInAccount.photoUrl,
            'full_name': signInAccount.displayName,
          },
        ),
      );

      return AuthResult.success;
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResult> logout() async {
    try {
      await FacebookAuth.instance.logOut();
      await GoogleSignIn().signOut();
      await _supabaseClient.auth.signOut();
      return AuthResult.success;
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResult> register(
    String email,
    String password, {
    required String fullName,
    required String username,
    required String phoneNumber,
  }) async {
    try {
      await _supabaseClient.auth.signUp(
          password: password,
          email: email,
          data: {
            'full_name': fullName,
            'username': username,
            'phone_number': phoneNumber,
          },
          phone: phoneNumber);
      return AuthResult.success;
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResult> resendEmailVerification(String email) async {
    try {
      log('resending email verification');
      _supabaseClient.auth.resend(email: email, type: OtpType.email);
      return AuthResult.success;
    } on AuthException catch (e) {
      log('error resending email verification');
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResult> resendResetEmail(String email) async {
    try {
      log('resending reset email');
      await _supabaseClient.auth.resetPasswordForEmail(email);
      return AuthResult.success;
    } on AuthException catch (e) {
      log('error resending reset email');
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  bool get isUserLoggedIn => _supabaseClient.auth.currentSession?.user != null;

  @override
  bool get emailVerified =>
      _supabaseClient.auth.currentUser?.emailConfirmedAt != null;

  @override
  User? get currentUser => _supabaseClient.auth.currentUser;
}
