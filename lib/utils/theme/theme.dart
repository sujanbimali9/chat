import 'dart:ui';

import 'package:chat/utils/color/color.dart';
import 'package:chat/utils/theme/button/filledbutton.dart';
import 'package:flutter/material.dart';

class TTheme {
  static ValueNotifier<ThemeMode> theme = ValueNotifier(ThemeMode.dark);

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

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'ABeeZee',
    appBarTheme: const AppBarTheme(
      backgroundColor: TColors.scaffoldBackgroundColor,
    ),
    scaffoldBackgroundColor: TColors.scaffoldBackgroundColor,
    primaryColor: TColors.primary,
    splashColor: TColors.primary.withAlpha(51),
    hoverColor: TColors.primary.withAlpha(51),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: TColors.navigationBarColor,
      indicatorColor: TColors.primary.withAlpha(150),
    ),
    focusColor: TColors.primary,
    colorScheme: const ColorScheme.light(primary: TColors.primary),
    filledButtonTheme: FilledButtonThemeData(style: TFilledButtonTheme.theme),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'ABeeZee',
    appBarTheme: const AppBarTheme(
      backgroundColor: TColors.darkScaffoldBackgroundColor,
    ),
    scaffoldBackgroundColor: TColors.darkScaffoldBackgroundColor,
    primaryColor: TColors.darkPrimary,
    splashColor: TColors.darkPrimary.withAlpha(51),
    hoverColor: TColors.darkPrimary.withAlpha(51),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: TColors.darkNavigationBarColor,
      indicatorColor: TColors.darkPrimary.withAlpha(150),
    ),
    focusColor: TColors.darkPrimary,
    colorScheme: const ColorScheme.dark(primary: TColors.darkPrimary),
    filledButtonTheme: FilledButtonThemeData(
      style: TFilledButtonTheme.darkTheme,
    ),
  );
}
