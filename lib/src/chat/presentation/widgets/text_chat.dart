import 'package:chat/core/common/model/chat.dart';
import 'package:chat/src/utils/color/color.dart';
import 'package:flutter/material.dart';

class TextChat extends StatelessWidget {
  const TextChat({
    super.key,
    required this.isUser,
    required this.chat,
    this.previousMessage,
    this.nextMessage,
    required this.isPreviousSameAuthor,
    required this.isNextSameAuthor,
    required this.isAfterDateSeparator,
    required this.isBeforeDateSeparator,
  });

  final bool isUser;
  final Chat chat;
  final Chat? previousMessage;
  final Chat? nextMessage;
  final bool isPreviousSameAuthor;
  final bool isNextSameAuthor;
  final bool isAfterDateSeparator;
  final bool isBeforeDateSeparator;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
        margin: isNextSameAuthor || isPreviousSameAuthor
            ? null
            : const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        constraints: BoxConstraints(maxWidth: screenSize.width * 0.8),
        decoration: BoxDecoration(
          color: isUser
              ? TColors.primary.withOpacity(0.2)
              : TColors.darkMessageBoxColor,
          borderRadius: getBorderRadius(
            isPreviousSameAuthor,
            isUser,
            isAfterDateSeparator,
            isBeforeDateSeparator,
            isNextSameAuthor,
          ),
        ),
        child: Text(
          chat.msg,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
              ),
        ));
  }
}

BorderRadius getBorderRadius(
    bool isPreviousSameAuthor,
    bool isUser,
    bool isAfterDateSeparator,
    bool isBeforeDateSeparator,
    bool isNextSameAuthor) {
  return BorderRadius.only(
    topLeft: isPreviousSameAuthor && !isUser && !isAfterDateSeparator
        ? Radius.zero
        : const Radius.circular(20),
    topRight: isPreviousSameAuthor && isUser && !isAfterDateSeparator
        ? Radius.zero
        : const Radius.circular(20),
    bottomLeft: !isUser && !isBeforeDateSeparator && isNextSameAuthor
        ? Radius.zero
        : const Radius.circular(20),
    bottomRight: isUser && !isBeforeDateSeparator && isNextSameAuthor
        ? Radius.zero
        : const Radius.circular(20),
  );
}
