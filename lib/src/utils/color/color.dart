import 'package:flutter/material.dart';

@immutable
class TColors {
  const TColors._();
  static const black = Color.fromARGB(255, 15, 15, 15);
  static const white = Color.fromARGB(255, 212, 212, 212);

  static const scaffoldBackgroundColor = Color.fromARGB(255, 242, 245, 246);
  static const navigationBarColor = Color.fromARGB(255, 216, 216, 216);
  static const primary = Color.fromARGB(255, 38, 130, 236);
  static final messageboxColor =
      const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2);
  static const secondary = Color.fromARGB(4, 240, 151, 151);
  static const error = Color.fromARGB(255, 240, 151, 151);
  static const success = Color.fromARGB(255, 38, 130, 236);
  static const warning = Color.fromARGB(255, 255, 159, 67);

  static const darkScaffoldBackgroundColor = Color.fromARGB(255, 18, 18, 18);
  static const darkNavigationBarColor = Color.fromARGB(255, 24, 24, 24);
  static const darkPrimary = Color.fromARGB(255, 38, 130, 236);
  static const darkSecondary = Color.fromARGB(121, 59, 56, 56);
  static const darkError = Color.fromARGB(255, 240, 151, 151);
  static const darkSuccess = Color.fromARGB(255, 38, 130, 236);
  static const darkWarning = Color.fromARGB(255, 255, 159, 67);
  static final darkMessageBoxColor =
      const Color.fromARGB(255, 167, 167, 167).withOpacity(0.2);
  static const darkLoadingBackgroundColor = Color.fromARGB(255, 50, 50, 50);
}
