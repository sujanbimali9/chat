import 'package:chat/src/chat/presentation/widgets/circular_container.dart';
import 'package:flutter/material.dart';

class MessageFieldIcons extends StatelessWidget {
  const MessageFieldIcons({
    super.key,
    required this.icon,
    required this.onPressed,
  });
  final Function() onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return TCircularContainer(
      margin: const EdgeInsets.all(2),
      borderRadius: 20,
      onPressed: onPressed,
      padding: const EdgeInsets.all(5),
      child: icon,
    );
  }
}
