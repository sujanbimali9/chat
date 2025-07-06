import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/core/common/model/media.dart';
import 'package:flutter/material.dart';

class ImageFullScreen extends StatelessWidget {
  final Media image;
  const ImageFullScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: image.url,
              child: AspectRatio(
                aspectRatio: image.metaData.aspectRatio!,
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: InteractiveViewer(
                    child: CachedNetworkImage(imageUrl: image.url),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: 30,
              left: 10,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))),
        ],
      ),
    );
  }
}
