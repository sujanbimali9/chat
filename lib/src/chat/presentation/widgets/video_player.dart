import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideo extends StatelessWidget {
  final String videoUrl;
  const FullScreenVideo({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          VideoPlayer(
            VideoPlayerController.networkUrl(
              Uri.parse(videoUrl),
            ),
          ),
        ],
      ),
    );
  }
}
