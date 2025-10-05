import 'package:chat/core/mixins/exception_handler_mixin.dart';
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
  Future<AuthResult> resetPassword(String email);
  Future<UserModel> loginWithEmailAndPassword(String email, String password);
  String? get isUserLoggedIn;
  bool get emailVerified;
  User? get currentUser;
}

class AuthRemoteDataSourceImp
    with NetworkExceptionHandlerMixin
    implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  final ApiService _apiService;

  AuthRemoteDataSourceImp(this._firebaseAuth, this._apiService);

  @override
  Future<UserModel> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return handleNetworkException(() async {
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
  Future<AuthResult> logout() async {
    return handleNetworkException(() async {
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
    return handleNetworkException(() async {
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
    return handleNetworkException(() async {
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
