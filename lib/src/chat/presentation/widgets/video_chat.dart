import 'package:chat/core/common/model/chat.dart';
import 'package:chat/src/chat/presentation/widgets/image_chat.dart';
import 'package:chat/src/chat/presentation/widgets/text_chat.dart';
import 'package:chat/src/chat/presentation/widgets/video_full_screen.dart';
import 'package:flutter/material.dart';

typedef VideoUrl = String;

class VideoChat extends StatelessWidget {
  final bool isUser;
  final Chat chat;
  final Chat? previousMessage;
  final Chat? nextMessage;
  final bool isPreviousSameAuthor;
  final bool isNextSameAuthor;
  final bool isAfterDateSeparator;
  final bool isBeforeDateSeparator;

  const VideoChat({
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final borderRadius = getBorderRadius(isPreviousSameAuthor, isUser,
        isAfterDateSeparator, isBeforeDateSeparator, isNextSameAuthor);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: screenSize.height * 0.3,
        maxWidth: screenSize.width * 0.8,
      ),
      child: GestureDetector(
        onTap: () {
          if (chat.status == MessageStatus.sending ||
              chat.status == MessageStatus.failed) return;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VideoFullScreen(chat: chat)));
        },
        child: AspectRatio(
          aspectRatio: chat.metadata!.aspectRatio!,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              ChatImageBuilder(
                borderRadius: borderRadius,
                image: chat.metadata!.thumbnail!,
                chat: chat,
              ),
              const Icon(
                Icons.play_arrow_rounded,
                size: 50,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
