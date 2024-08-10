import 'package:chat/src/utils/color/color.dart';
import 'package:flutter/material.dart';

class CustomDrawerWidgets extends StatefulWidget {
  final Widget home;
  final Widget drawer;
  const CustomDrawerWidgets(
      {super.key, required this.home, required this.drawer});

  @override
  State<CustomDrawerWidgets> createState() => _CustomDrawerWidgetsState();
}

class _CustomDrawerWidgetsState extends State<CustomDrawerWidgets>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double maxSlide;
  late bool _canBeDragged;
  late num minDragStartEdge;
  late num maxDragStartEdge;

  @override
  void initState() {
    _canBeDragged = false;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft =
        _controller.isDismissed && details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight =
        _controller.isCompleted && details.globalPosition.dx > maxDragStartEdge;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / maxSlide;
      _controller.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_controller.isDismissed || _controller.isCompleted) return;
    if (details.velocity.pixelsPerSecond.dx.abs() >= 365) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;
      _controller.fling(velocity: visualVelocity);
    } else if (_controller.value < 0.5) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    maxSlide = MediaQuery.of(context).size.width * 0.8;
    minDragStartEdge = MediaQuery.of(context).size.width * 0.2;
    maxDragStartEdge = MediaQuery.of(context).size.width * 0.8;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkMode ? null : Colors.grey,
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double slider = maxSlide * _controller.value;
            double scale = 1 - (_controller.value * 0.3);
            return Stack(
              children: [
                Container(
                  color: TColors.scaffoldBackgroundColor,
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.2),
                  child: widget.drawer,
                ),
                Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..translate(slider)
                    ..scale(scale),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(
                          Radius.circular(_controller.value * 20)),
                      child: widget.home),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
