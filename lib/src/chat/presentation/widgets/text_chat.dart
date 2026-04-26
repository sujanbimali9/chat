import 'package:chat/src/chat/presentation/widgets/gradient_chat_painter.dart';
import 'package:flutter/material.dart';

import 'package:chat/core/common/model/chat.dart';
import 'package:chat/utils/color/color.dart';

class TextChat extends StatelessWidget {
  const TextChat({
    super.key,
    required this.isUser,
    required this.chat,
    required this.borderRadius,
  });

  final bool isUser;
  final Chat chat;
  final BorderRadius borderRadius;

  List<Color> getColors(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (isUser) {
      return brightness == Brightness.dark
          ? TColors.userMessageBoxColorDark
          : TColors.userMessageBoxColor;
    } else {
      return brightness == Brightness.dark
          ? TColors.otherMessageBoxColorDark
          : TColors.otherMessageBoxColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size.width * 0.7),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: CustomPaint(
            painter: GradientChatPainter(
              context: context,
              scrollableState: Scrollable.of(context),
              colors: getColors(context),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: Text(
                chat.msg,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
