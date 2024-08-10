import 'package:chat/core/common/model/chat.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoFullScreen extends StatefulWidget {
  final Chat chat;
  const VideoFullScreen({super.key, required this.chat});

  @override
  State<VideoFullScreen> createState() => _VideoFullScreenState();
}

class _VideoFullScreenState extends State<VideoFullScreen> {
  late final VideoPlayerController controller;
  @override
  void initState() {
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.chat.msg))
      ..initialize().then((value) {
        controller.play();
        setState(() {});
      });
    controller.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  listener() {
    if (controller.value.isCompleted || controller.value.isBuffering) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (controller.value.isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
          if (controller.value.isBuffering || (!controller.value.isInitialized))
            const Center(child: CircularProgressIndicator())
          else
            Center(
              child: Visibility(
                visible: !controller.value.isPlaying,
                child: IconButton(
                  onPressed: () {
                    if (!controller.value.isInitialized) return;
                    controller.value.isPlaying
                        ? controller.pause()
                        : controller.play();
                    setState(() {});
                  },
                  icon: (!controller.value.isInitialized) ||
                          controller.value.isCompleted
                      ? const Icon(Icons.play_arrow)
                      : const Icon(Icons.pause),
                ),
              ),
            ),
          Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                  onPressed: () {
                    controller.pause();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back))),
        ],
      ),
    );
  }
}
