import 'package:chat/core/common/model/media.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoFullScreen extends StatefulWidget {
  const VideoFullScreen({super.key, required this.video});
  final Media video;

  @override
  State<VideoFullScreen> createState() => _VideoFullScreenState();
}

class _VideoFullScreenState extends State<VideoFullScreen> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
      Uri.parse(widget.video.url),
    ));
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlickVideoPlayer(
      flickManager: flickManager,
      wakelockEnabledFullscreen: true,
      wakelockEnabled: false,
      preferredDeviceOrientationFullscreen: const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      preferredDeviceOrientation: const [DeviceOrientation.portraitUp],
    ));
  }
}
