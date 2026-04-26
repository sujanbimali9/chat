import 'package:flutter/material.dart';

@immutable
class TColors {
  const TColors._();
  static const primary = Color.fromARGB(255, 38, 130, 236);
  static const fileMessageBoxColor = Color.fromARGB(255, 70, 69, 69);

  static const otherMessageBoxColor = [
    Color.fromARGB(146, 61, 93, 17),
    Color.fromARGB(148, 110, 3, 204),
  ];
  static const otherMessageBoxColorDark = [
    Color.fromARGB(255, 61, 93, 17),
    Color.fromARGB(255, 110, 3, 204),
  ];
  static const userMessageBoxColor = [
    Color.fromARGB(148, 74, 21, 180),
    Color.fromARGB(157, 0, 111, 230),
  ];
  static const userMessageBoxColorDark = [
    Color.fromARGB(255, 74, 21, 180),
    Color.fromARGB(255, 0, 111, 230),
  ];
  static const replyColor = Color.fromARGB(255, 116, 116, 116);
}
