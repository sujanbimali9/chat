import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/core/common/model/media.dart';
import 'package:flutter/material.dart';

import 'package:chat/core/common/model/chat.dart';
import 'package:chat/src/chat/presentation/widgets/image_full_screen.dart';

class ImageChat extends StatelessWidget {
  const ImageChat({
    super.key,
    required this.image,
    this.borderRadius,
    required this.status,
  });
  final Media image;
  final MessageStatus status;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: screenSize.height * 0.3, maxWidth: screenSize.width * 0.8),
      child: Hero(
        tag: image.url,
        child: ChatImageBuilder(
          status: status,
          borderRadius: borderRadius,
          image: image.url,
          onPressed: () {
            if (!(status.isSent)) return;

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageFullScreen(image: image),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChatImageBuilder extends StatelessWidget {
  const ChatImageBuilder({
    super.key,
    required this.status,
    required this.borderRadius,
    required this.image,
    this.onPressed,
  });

  final MessageStatus status;
  final BorderRadius? borderRadius;
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
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: status.isSending
              ? Container(
                  color: Colors.grey,
                )
              : status.isFailed
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
                      fit: BoxFit.fill,
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
