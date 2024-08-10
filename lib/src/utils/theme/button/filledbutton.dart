import 'package:chat/src/utils/color/color.dart';
import 'package:flutter/material.dart';

class TFilledButtonTheme {
  static final theme = FilledButton.styleFrom(
      backgroundColor: TColors.primary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))));
  static final darkTheme = FilledButton.styleFrom(
      backgroundColor: TColors.darkPrimary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))));
}
