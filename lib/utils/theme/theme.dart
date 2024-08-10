import 'package:chat/utils/color/color.dart';
import 'package:chat/utils/theme/button/filledbutton.dart';
import 'package:chat/utils/theme/text_theme/text_theme.dart';
import 'package:chat/utils/theme/textfield/textfieldtheme.dart';
import 'package:flutter/material.dart';

class TTheme {
  static ThemeData theme = ThemeData(
      textTheme: ThemeData.light().textTheme.copyWith(
            bodyLarge: TTextTheme.bodyLarge,
            bodyMedium: TTextTheme.bodyMedium,
            bodySmall: TTextTheme.bodySmall,
            headlineLarge: TTextTheme.headlineLarge,
            headlineMedium: TTextTheme.headlineMedium,
            headlineSmall: TTextTheme.headlineSmall,
          ),
      hoverColor: TColors.primary.withOpacity(0.1),
      appBarTheme:
          const AppBarTheme(backgroundColor: TColors.scaffoldBackgroundColor),
      scaffoldBackgroundColor: TColors.scaffoldBackgroundColor,
      primaryColor: TColors.primary,
      splashColor: TColors.primary.withOpacity(0.2),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: TColors.navigationBarColor,
        indicatorColor: TColors.primary.withOpacity(0.6),
      ),
      focusColor: TColors.primary,
      colorScheme: const ColorScheme.light(primary: TColors.primary),
      filledButtonTheme: FilledButtonThemeData(style: TFilledButtonTheme.theme),
      inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: TTextFieldTheme.focusBorder,
          disabledBorder: TTextFieldTheme.unfocusBorder,
          focusedErrorBorder: TTextFieldTheme.errorBorder,
          errorBorder: TTextFieldTheme.errorBorder,
          border: TTextFieldTheme.unfocusBorder,
          enabledBorder: TTextFieldTheme.unfocusBorder));

  static ThemeData darkTheme = ThemeData(
      textTheme: ThemeData.dark().textTheme.copyWith(
            bodyLarge: TTextTheme.bodyLargeDark,
            bodyMedium: TTextTheme.bodyMediumDark,
            bodySmall: TTextTheme.bodySmallDark,
            headlineLarge: TTextTheme.headlineLargeDark,
            headlineMedium: TTextTheme.headlineMediumDark,
            headlineSmall: TTextTheme.headlineSmallDark,
          ),
      cardTheme: CardTheme(
          color: TColors.darkScaffoldBackgroundColor.withOpacity(0.5)),
      hoverColor: TColors.darkPrimary.withOpacity(0.1),
      appBarTheme: const AppBarTheme(
          backgroundColor: TColors.darkScaffoldBackgroundColor),
      scaffoldBackgroundColor: TColors.darkScaffoldBackgroundColor,
      primaryColor: TColors.darkPrimary,
      splashColor: TColors.darkPrimary.withOpacity(0.2),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: TColors.darkNavigationBarColor,
        indicatorColor: TColors.darkPrimary.withOpacity(0.6),
      ),
      focusColor: TColors.darkPrimary,
      colorScheme: const ColorScheme.dark(primary: TColors.darkPrimary),
      filledButtonTheme:
          FilledButtonThemeData(style: TFilledButtonTheme.darkTheme),
      inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: TTextFieldTheme.darkFocusBorder,
          disabledBorder: TTextFieldTheme.darkUnfocusBorder,
          focusedErrorBorder: TTextFieldTheme.darkErrorBorder,
          errorBorder: TTextFieldTheme.darkErrorBorder,
          border: TTextFieldTheme.darkUnfocusBorder,
          enabledBorder: TTextFieldTheme.darkUnfocusBorder));
}
