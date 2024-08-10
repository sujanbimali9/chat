import 'package:chat/utils/color/color.dart';
import 'package:flutter/material.dart';

class TTextFieldTheme {
  static const InputBorder focusBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: TColors.primary));
  static const InputBorder errorBorder =
      OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1));
  static const InputBorder unfocusBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 0.5, style: BorderStyle.solid));

  static const InputBorder darkFocusBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: TColors.darkPrimary));
  static const InputBorder darkErrorBorder =
      OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1));
  static const InputBorder darkUnfocusBorder = OutlineInputBorder(
      borderSide:
          BorderSide(width: 0.5, style: BorderStyle.solid, color: Colors.grey));
}
