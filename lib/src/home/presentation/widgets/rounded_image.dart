import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/src/home/presentation/widgets/circular_container.dart';
import 'package:flutter/material.dart';

class TRoundedImage extends StatelessWidget {
  const TRoundedImage({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.backgroundImage,
    this.isNetwork = true,
    required this.image,
    this.fit,
    this.showBorder = false,
    this.onTap,
    this.padding,
    this.constraints,
    this.showProgress = false,
  });

  final double? height;
  final double? width;
  final double? borderRadius;
  final String? backgroundImage;
  final bool isNetwork;
  final bool showBorder;
  final String image;
  final BoxFit? fit;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    Widget progressBuilder(double? progress) {
      return Container(
        height: height,
        width: width,
        color: Colors.grey,
        child: showProgress
            ? Column(
                children: [
                  const Spacer(),
                  if (progress != null) LinearProgressIndicator(value: progress)
                ],
              )
            : null,
      );
    }

    return TCircularContainer(
      constraints: constraints,
      showBorder: showBorder,
      onPressed: onTap,
      borderRadius: borderRadius ?? height ?? 50,
      padding: padding,
      height: height,
      width: width,
      backgroundImage: backgroundImage,
      isNetwork: isNetwork,
      child: ClipRRect(
        borderRadius:
            BorderRadius.all(Radius.circular(borderRadius ?? height ?? 50)),
        child: isNetwork
            ? CachedNetworkImage(
                imageUrl: image,
                fit: fit ?? BoxFit.contain,
                errorListener: (value) {},
                errorWidget: (context, url, error) => Container(
                    height: height,
                    width: width,
                    color: Colors.grey,
                    child: const Icon(Icons.error, color: Colors.red)),
                progressIndicatorBuilder: (context, url, progress) {
                  return progressBuilder(progress.progress);
                },
              )
            : Image(
                image: FileImage(File(image)),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return progressBuilder(
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null);
                },
                fit: fit ?? BoxFit.cover,
              ),
      ),
    );
  }
}
