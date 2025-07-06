import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class GradientChatPainter extends CustomPainter {
  final BuildContext context;
  final ScrollableState scrollableState;
  final List<Color> colors;

  GradientChatPainter(
      {required this.context,
      required this.scrollableState,
      required this.colors})
      : super(repaint: scrollableState.position);

  @override
  void paint(Canvas canvas, Size size) {
    final scrollableBox =
        scrollableState.context.findRenderObject() as RenderBox;
    final scrollableRect = Offset.zero & scrollableBox.size;
    final chatBox = context.findRenderObject() as RenderBox;
    final chatOffset =
        chatBox.localToGlobal(Offset.zero, ancestor: scrollableBox);
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        scrollableRect.topCenter,
        scrollableRect.bottomCenter,
        colors,
        [0.0, 1.0],
        TileMode.clamp,
        Matrix4.translationValues(0.0, -chatOffset.dy, 0).storage,
      );

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant GradientChatPainter oldDelegate) {
    return oldDelegate.scrollableState != scrollableState ||
        oldDelegate.colors != colors ||
        oldDelegate.context != context;
  }
}
