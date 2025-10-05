import 'dart:ui';

import 'package:chat/utils/color/color.dart';
import 'package:flutter/material.dart';

class TTheme {
  static ValueNotifier<ThemeMode> theme = ValueNotifier(ThemeMode.system);

  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: TColors.primary,
      primary: TColors.primary,
      brightness: Brightness.light,
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: TColors.primary,
      primary: TColors.primary,
      brightness: Brightness.dark,
    ),
  );

  static void changeThemeMode(ThemeMode mode) {
    theme.value = mode;
  }

  static void toggleThemeMode() {
    theme.value = theme.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static ThemeMode get currentTheme => theme.value;

  static bool get isDarkMode {
    if (currentTheme == ThemeMode.system) {
      return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    }
    return currentTheme == ThemeMode.dark;
  }
}
