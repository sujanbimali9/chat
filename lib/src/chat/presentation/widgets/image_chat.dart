import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/src/chat/presentation/widgets/image_full_screen.dart';
import 'package:chat/src/chat/presentation/widgets/text_chat.dart';
import 'package:flutter/material.dart';

class ImageChat extends StatelessWidget {
  const ImageChat(
      {super.key,
      required this.chat,
      required this.isUser,
      this.previousMessage,
      this.nextMessage,
      required this.isPreviousSameAuthor,
      required this.isNextSameAuthor,
      required this.isAfterDateSeparator,
      required this.isBeforeDateSeparator});
  final Chat chat;
  final bool isUser;

  final Chat? previousMessage;

  final Chat? nextMessage;

  final bool isPreviousSameAuthor;

  final bool isNextSameAuthor;

  final bool isAfterDateSeparator;

  final bool isBeforeDateSeparator;

  @override
  Widget build(BuildContext context) {
    final String image = chat.msg;
    final double aspectRatio = chat.metadata!.aspectRatio!;
    final screenSize = MediaQuery.of(context).size;
    final borderRadius = getBorderRadius(isPreviousSameAuthor, isUser,
        isAfterDateSeparator, isBeforeDateSeparator, isNextSameAuthor);

    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: screenSize.height * 0.3, maxWidth: screenSize.width * 0.8),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Hero(
          tag: chat.id,
          child: ChatImageBuilder(
            chat: chat,
            borderRadius: borderRadius,
            image: image,
            onPressed: () {
              if (!(chat.status.isSent)) return;

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ImageFullScreen(chat: chat)));
            },
          ),
        ),
      ),
    );
  }
}

class ChatImageBuilder extends StatelessWidget {
  const ChatImageBuilder({
    super.key,
    required this.chat,
    required this.borderRadius,
    required this.image,
    this.onPressed,
  });

  final Chat chat;
  final BorderRadius borderRadius;
  final String image;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    Widget progressBuilder(double? progress) {
      return Container(
        color: Colors.grey,
        child: Column(
          children: [
            const Spacer(),
            if (progress != null) LinearProgressIndicator(value: progress)
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
          borderRadius: borderRadius,
          child: chat.status.isSending
              ? Container(
                  color: Colors.grey,
                )
              : chat.status.isFailed
                  ? Image.file(
                      File(image),
                      fit: BoxFit.contain,
                      errorBuilder: (context, url, error) => Container(
                          color: Colors.grey,
                          child: const Icon(Icons.error, color: Colors.red)),
                      // frameBuilder: (context, child, progress, complete) =>
                      //     complete
                      //         ? child
                      //         : progressBuilder(progress?.toDouble()),
                    )
                  : CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.contain,
                      errorListener: (value) {},
                      errorWidget: (context, url, error) => Container(
                          color: Colors.grey,
                          child: const Icon(Icons.error, color: Colors.red)),
                      progressIndicatorBuilder: (context, url, progress) {
                        return progressBuilder(progress.progress);
                      },
                    )),
    );
  }
}
