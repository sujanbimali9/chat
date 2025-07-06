import 'package:flutter/foundation.dart' show immutable;

@immutable
class AuthConstant {
  static const accountExistWithDifferentCredential =
      "account-exists-with-different-credential";
  static const googleCom = 'google.com';
  static const invalidEmail = "Invalid Email";
  static const emailScope = 'email';
  static const appName = 'Riverpod App';
  static const loginToChat = 'Login to Chat';
  static const chat = 'Chat';
  static const login = 'Login';
  static const signUp = 'Sign Up';
  static const orSignInWith = 'or SignIn with';
  static const logout = 'Logout';
  static const logOutMessage = 'Are you sure you want to log out?';
  static const google = 'Google';
  static const facebook = 'Facebook';
  static const email = 'Email';
  static const password = 'Password';
  static const fullName = 'Full Name';
  static const phoneNumber = 'Phone Number';
  static const username = 'Username';

  const AuthConstant._();
}
