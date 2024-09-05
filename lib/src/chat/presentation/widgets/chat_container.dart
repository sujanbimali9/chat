import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/src/chat/presentation/widgets/file_chat.dart';
import 'package:chat/src/chat/presentation/widgets/image_chat.dart';
import 'package:chat/src/chat/presentation/widgets/rounded_container.dart';
import 'package:chat/src/chat/presentation/widgets/video_chat.dart';
import 'package:flutter/material.dart';

import 'text_chat.dart';

class ChatContainer extends StatelessWidget {
  const ChatContainer({
    super.key,
    required this.chat,
    required this.currentUser,
    required this.user,
    this.nextChat,
    this.previousChat,
    required this.isAfterDateSeparator,
    required this.isBeforeDateSeparator,
  });
  final Chat chat;
  final User currentUser;
  final User user;
  final Chat? nextChat;
  final Chat? previousChat;
  final bool isAfterDateSeparator;
  final bool isBeforeDateSeparator;

  @override
  Widget build(BuildContext context) {
    bool isPreviousSameAuthor = false;
    bool isNextSameAuthor = false;
    if (previousChat != null && previousChat!.fromId == chat.fromId) {
      isPreviousSameAuthor = true;
    }
    if (nextChat != null && nextChat!.fromId == chat.fromId) {
      isNextSameAuthor = true;
    }
    final isUser = chat.fromId == currentUser.id;
    print('chat.status: ${chat.status}');
    print('chat.type: ${chat}');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser && (!isNextSameAuthor || isBeforeDateSeparator))
          TRoundedImage(
            isNetwork: true,
            image: user.profileImage,
            height: 25,
            width: 25,
          )
        else
          const SizedBox(width: 25),
        if (!isUser) const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (isAfterDateSeparator) const SizedBox(height: 10),
              if (chat.type.isText)
                TextChat(
                  chat: chat,
                  isUser: isUser,
                  isAfterDateSeparator: isAfterDateSeparator,
                  isBeforeDateSeparator: isBeforeDateSeparator,
                  nextMessage: nextChat,
                  previousMessage: previousChat,
                  isPreviousSameAuthor: isPreviousSameAuthor,
                  isNextSameAuthor: isNextSameAuthor,
                )
              else if (chat.type.isImage)
                ImageChat(
                  chat: chat,
                  isUser: isUser,
                  isAfterDateSeparator: isAfterDateSeparator,
                  isBeforeDateSeparator: isBeforeDateSeparator,
                  nextMessage: nextChat,
                  previousMessage: previousChat,
                  isPreviousSameAuthor: isPreviousSameAuthor,
                  isNextSameAuthor: isNextSameAuthor,
                )
              else if (chat.type.isFile)
                FileChat(
                  chat: chat,
                  isUser: isUser,
                  isAfterDateSeparator: isAfterDateSeparator,
                  isBeforeDateSeparator: isBeforeDateSeparator,
                  nextMessage: nextChat,
                  previousMessage: previousChat,
                  isPreviousSameAuthor: isPreviousSameAuthor,
                  isNextSameAuthor: isNextSameAuthor,
                )
              else if (chat.type.isVideo)
                VideoChat(
                  chat: chat,
                  isUser: isUser,
                  isAfterDateSeparator: isAfterDateSeparator,
                  isBeforeDateSeparator: isBeforeDateSeparator,
                  nextMessage: nextChat,
                  previousMessage: previousChat,
                  isPreviousSameAuthor: isPreviousSameAuthor,
                  isNextSameAuthor: isNextSameAuthor,
                ),
              if (!chat.status.isSent) const SizedBox(height: 5),
              if (chat.status.isSending)
                const SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator(strokeWidth: 1))
              else if (chat.status.isFailed)
                const Icon(Icons.error, color: Colors.red, size: 15),
              const SizedBox(height: 4),
              if (!isNextSameAuthor || isBeforeDateSeparator)
                const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
