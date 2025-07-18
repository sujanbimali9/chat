import 'dart:developer';

import 'package:chat/core/exception/exception.dart';
import 'package:chat/src/auth/data/model/auth_result.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/utils/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

@immutable
abstract interface class AuthRemoteDataSource {
  Future<UserModel> register(
    String email,
    String password, {
    required String name,
    required String phoneNumber,
  });
  Future<AuthResult> logout();
  Future<AuthResult> forgotPassword(String email);
  Future<AuthResult> resetPassword(String email);
  Future<UserModel> loginWithGmail();
  Future<UserModel> loginWithFacebook();
  Future<UserModel> loginWithEmailAndPassword(String email, String password);
  String? get isUserLoggedIn;
  bool get emailVerified;
  User? get currentUser;
}

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  final ApiService _apiService;

  AuthRemoteDataSourceImp(this._firebaseAuth, this._apiService);

  Future<T> _handleException<T>(
    Future<T> Function() operation, {
    String context = '',
  }) async {
    try {
      return await operation();
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth Exception: ${e.message}',
        name: 'AuthRemoteDataSource.$context',
      );
      throw ServerException(e.message ?? 'error');
    } on ServerException catch (e) {
      log(
        'Server Exception: ${e.message}',
        name: 'AuthRemoteDataSource.$context',
      );
      rethrow;
    } catch (e) {
      log('Unexpected Exception: $e', name: 'AuthRemoteDataSource.$context');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthResult> forgotPassword(String email) async {
    return _handleException(() async {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return AuthResult.success;
    }, context: 'AuthRemoteDataSourceImp.forgotPassword');
  }

  @override
  Future<UserModel> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return _handleException(() async {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = _firebaseAuth.currentUser!.uid;
      final user = await _apiService.post<Map<String, dynamic>>(
        'auth/signin',
        data: {'id': userId, 'email': email},
      );
      return UserModel.fromJson(user);
    }, context: 'loginWithEmailAndPassword');
  }

  @override
  Future<UserModel> loginWithFacebook() async {
    return _handleException(() async {
      final facebookAuth = FacebookAuth.instance;
      final loginResult = await facebookAuth.login();
      if (loginResult.status != LoginStatus.success) {
        throw const AuthException('login failed try again later');
      }
      final accessToken = loginResult.accessToken;
      if (accessToken == null) {
        throw const AuthException('login failed try again later');
      }
      final credential = FacebookAuthProvider.credential(
        accessToken.tokenString,
      );
      final res = await _firebaseAuth.signInWithCredential(credential);
      if (res.user == null) {
        throw const ServerException('login failed try again later');
      }
      final firebaseUser = res.user!;

      final user = await _apiService.post<Map<String, dynamic>>(
        'auth/social',
        data: {
          'id': firebaseUser.uid,
          'email': firebaseUser.email,
          'name': firebaseUser.displayName,
          'avatar_url': firebaseUser.photoURL,
          'phone': firebaseUser.phoneNumber,
        },
      );
      return UserModel.fromJson(user);
    }, context: 'loginWithFacebook');
  }

  @override
  Future<UserModel> loginWithGmail() async {
    return _handleException(() async {
      final googleSignIn = GoogleSignIn();
      final signinAccount = await googleSignIn.signIn();
      if (signinAccount == null) {
        throw const AuthException('login failed try again later');
      }
      final googleAuth = await signinAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final res = await _firebaseAuth.signInWithCredential(credential);

      if (res.user == null) {
        throw const ServerException('login failed try again later');
      }

      final firebaseUser = res.user!;

      final user = await _apiService.post<Map<String, dynamic>>(
        'auth/social',
        data: {
          'id': firebaseUser.uid,
          'email': firebaseUser.email,
          'name': firebaseUser.displayName,
          'profileImage': firebaseUser.photoURL,
          'phone': firebaseUser.phoneNumber,
        },
      );
      return UserModel.fromJson(user);
    }, context: 'loginWithGmail');
  }

  @override
  Future<AuthResult> logout() async {
    return _handleException(() async {
      final googleSignIn = GoogleSignIn();
      final facebookAuth = FacebookAuth.instance;
      await _firebaseAuth.signOut();
      await googleSignIn.signOut();
      await facebookAuth.logOut();
      await FirebaseMessaging.instance.deleteToken();
      return AuthResult.success;
    }, context: 'logout');
  }

  @override
  Future<UserModel> register(
    String email,
    String password, {
    required String name,
    required String phoneNumber,
  }) async {
    return _handleException(() async {
      final res = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = res.user!.uid;
      final user = await _apiService.post(
        'auth/signup',
        data: {
          'id': userId,
          'email': email,
          'name': name,
          'phone': phoneNumber,
        },
      );
      return UserModel.fromJson(user);
    }, context: 'register');
  }

  @override
  Future<AuthResult> resetPassword(String email) async {
    return _handleException(() async {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return AuthResult.success;
    }, context: 'resetPassword');
  }

  @override
  String? get isUserLoggedIn => _firebaseAuth.currentUser?.uid;

  @override
  bool get emailVerified => _firebaseAuth.currentUser?.emailVerified ?? false;

  @override
  User? get currentUser => _firebaseAuth.currentUser;
}
