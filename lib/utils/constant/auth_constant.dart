import 'package:flutter/foundation.dart' show immutable;

@immutable
class AuthConstant {
  static const accountExistWithDifferentCredential =
      "account-exists-with-different-credential";
  static const googleCom = 'google.com';
  static const invalidEmail = "Invalid Email";
  static const emailScope = 'email';

  static const String appName = 'Riverpod App';
  static const String loginToChat = 'Login to Chat';
  static const String chat = 'Chat';
  static const String login = 'Login';
  static const String signIn = 'Sign In';
  static const String orSignInWith = 'or SignIn with';
  static const String logout = 'Logout';
  static const String logOutMessage = 'Are you sure you want to log out?';
  static const String google = 'Google';
  static const String facebook = 'Facebook';
  static const String email = 'Email';
  static const String password = 'Password';
  const AuthConstant._();
}
