import 'dart:async';

import 'package:chat/core/common/loading/loading_screen_controller.dart';
import 'package:chat/utils/color/color.dart';
import 'package:flutter/material.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;
  LoadingScreenController? _controller;

  void show({required BuildContext context, String message = 'Loading'}) {
    if (_controller?.update(message) ?? false) {
      return;
    } else {
      _controller = showOverlay(context: context, text: message);
      return;
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController? showOverlay(
      {required BuildContext context, required String text}) {
    final textController = StreamController<String>();
    textController.add(text);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return Center(
          child: Material(
            child: Container(
              padding: const EdgeInsets.all(8),
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.6,
                minHeight: size.height * 0.2,
              ),
              decoration: BoxDecoration(
                  color: isDarkTheme ? TColors.white : TColors.dark,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  StreamBuilder<String>(
                      stream: textController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 20,
                                    color: isDarkTheme
                                        ? TColors.black
                                        : TColors.white),
                          );
                        }
                        return const SizedBox();
                      }),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(overlayEntry);

    return LoadingScreenController(
      close: () {
        textController.close();
        overlayEntry.remove();
        return true;
      },
      show: (String? text) {
        Overlay.of(context).insert(overlayEntry);
      },
      update: (String text) {
        textController.add(text);
        return true;
      },
    );
  }
}
