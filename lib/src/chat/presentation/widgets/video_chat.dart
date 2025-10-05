import 'package:chat/core/common/model/media.dart';
import 'package:flutter/material.dart';

import 'package:chat/core/common/model/chat.dart';
import 'package:chat/src/chat/presentation/widgets/image_chat.dart';
import 'package:chat/src/chat/presentation/widgets/video_full_screen.dart';

typedef VideoUrl = String;

class VideoChat extends StatelessWidget {
  final bool isUser;
  final Media video;
  final MessageStatus status;
  final BorderRadius? borderRadius;

  const VideoChat({
    super.key,
    required this.video,
    required this.status,
    required this.isUser,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (status.isSending || status.isFailed) return;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VideoFullScreen(video: video),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          ChatImageBuilder(
            borderRadius: borderRadius,
            image: video.metadata.thumbnail!,
            status: status,
          ),
          const Icon(Icons.play_arrow_rounded, size: 50, color: Colors.white),
        ],
      ),
    );
  }
}
