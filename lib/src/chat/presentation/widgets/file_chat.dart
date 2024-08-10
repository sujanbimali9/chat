import 'package:chat/core/common/model/chat.dart';
import 'package:chat/src/chat/presentation/widgets/circular_container.dart';
import 'package:chat/src/chat/presentation/widgets/text_chat.dart';
import 'package:chat/utils/color/color.dart';
import 'package:flutter/material.dart';

class FileChat extends StatelessWidget {
  final Chat chat;
  const FileChat({
    super.key,
    required this.chat,
    required this.isUser,
    this.previousMessage,
    this.nextMessage,
    required this.isPreviousSameAuthor,
    required this.isNextSameAuthor,
    required this.isAfterDateSeparator,
    required this.isBeforeDateSeparator,
  });
  final bool isUser;

  final Chat? previousMessage;

  final Chat? nextMessage;

  final bool isPreviousSameAuthor;

  final bool isNextSameAuthor;

  final bool isAfterDateSeparator;

  final bool isBeforeDateSeparator;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(maxWidth: size.width * 0.7),
      decoration: BoxDecoration(
          color: TColors.darkMessageBoxColor,
          borderRadius: getBorderRadius(isPreviousSameAuthor, isUser,
              isAfterDateSeparator, isBeforeDateSeparator, isNextSameAuthor)),
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TCircularContainer(
            backgroundColor: TColors.primary.withOpacity(0.5),
            padding: const EdgeInsets.all(7),
            borderRadius: 30,
            child: const Icon(Icons.insert_drive_file_sharp),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(chat.metadata!.title ?? chat.msg,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
