import 'package:chat/src/home/presentation/widgets/circular_container.dart';
import 'package:chat/src/home/presentation/widgets/rounded_image.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage(
      {super.key,
      required this.image,
      this.isNetwork = false,
      this.fit,
      this.height,
      this.width,
      this.borderRadius,
      this.backgroundImage,
      this.backgroundColor,
      this.showBorder = false,
      this.onTap,
      this.showActive = true});

  final double? height;
  final double? width;
  final double? borderRadius;
  final String? backgroundImage;
  final bool isNetwork;
  final bool showBorder;
  final bool showActive;
  final Color? backgroundColor;
  final String image;
  final BoxFit? fit;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TRoundedImage(
            onTap: onTap,
            showBorder: showBorder,
            height: height,
            width: width,
            borderRadius: borderRadius,
            backgroundImage: backgroundImage,
            isNetwork: isNetwork,
            image: image,
            fit: fit),
        if (showActive)
          Positioned(
              right: height != null ? 0.1 * height! : 8,
              bottom: width != null ? 0.1 * width! : 8,
              child: const TCircularContainer(
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(2),
                borderRadius: 8,
                height: 10,
                width: 10,
                child: TCircularContainer(
                  borderRadius: 8,
                  height: 8,
                  width: 8,
                  backgroundColor: Colors.green,
                ),
              ))
      ],
    );
  }
}
