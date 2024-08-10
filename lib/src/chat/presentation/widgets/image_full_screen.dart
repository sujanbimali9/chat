import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:flutter/material.dart';

class ImageFullScreen extends StatelessWidget {
  final Chat chat;
  const ImageFullScreen({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 30,
              left: 10,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))),
          Center(
            child: AspectRatio(
              aspectRatio: chat.metadata!.aspectRatio!,
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: InteractiveViewer(
                    child: CachedNetworkImage(imageUrl: chat.msg)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
