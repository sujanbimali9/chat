import 'package:flutter/foundation.dart';

typedef CloseLoadingScreen = bool Function();
typedef ShowLoadingScreen = void Function(String? text);
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final ShowLoadingScreen show;
  final UpdateLoadingScreen update;

  const LoadingScreenController({
    required this.close,
    required this.show,
    required this.update,
  });
}
