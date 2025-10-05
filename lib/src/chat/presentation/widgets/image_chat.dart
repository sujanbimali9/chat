import 'dart:io';
import 'dart:typed_data';

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
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      constraints: BoxConstraints(
        maxHeight: screenSize.height * 0.3,
        maxWidth: screenSize.width * 0.8,
      ),
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

class ChatImageBuilder extends StatefulWidget {
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
  State<ChatImageBuilder> createState() => _ChatImageBuilderState();
}

class _ChatImageBuilderState extends State<ChatImageBuilder> {
  Uint8List? _localImageByte;

  @override
  void initState() {
    if (widget.status.isSending) _loadLocalImage();
    super.initState();
  }

  @override
  didChangeDependencies() {
    if (widget.status.isSending) _loadLocalImage();
    super.didChangeDependencies();
  }

  Future<void> _loadLocalImage() async {
    final byteData = await File(widget.image).readAsBytes();
    if (mounted) {
      setState(() {
        _localImageByte = byteData;
      });
    }
  }

  @override
  dispose() {
    _localImageByte = null;
    super.dispose();
  }

  Widget _buildImage() {
    if (_localImageByte == null && widget.status.isSending) {
      return Container(color: Colors.grey);
    } else if (widget.status.isFailed) {
      return Image.file(File(widget.image), fit: BoxFit.cover);
    } else if (_localImageByte != null && widget.status.isSent) {
      return FadeInImage(
        placeholder: MemoryImage(_localImageByte!),
        image: CachedNetworkImageProvider(widget.image),
        fit: BoxFit.cover,
      );
    }
    return CachedNetworkImage(
      imageUrl: widget.image,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(color: Colors.grey),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: widget.onPressed, child: _buildImage());
  }
}
