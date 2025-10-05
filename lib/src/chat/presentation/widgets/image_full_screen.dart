import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/core/common/model/media.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageFullScreen extends StatelessWidget {
  final Media image;
  const ImageFullScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Hero(
            tag: image.url,
            child: PhotoView(
              minScale: PhotoViewComputedScale.contained,

              imageProvider: CachedNetworkImageProvider(image.url),
            ),
          ),

          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
