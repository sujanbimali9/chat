import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TCircularContainer extends StatelessWidget {
  const TCircularContainer({
    super.key,
    this.backgroundColor,
    this.child,
    this.height,
    this.width,
    this.borderRadius,
    this.padding,
    this.margin,
    this.backgroundImage,
    this.isNetwork = false,
    this.onPressed,
    this.showBorder,
    this.borderColor,
    this.constraints,
  });

  final Color? backgroundColor;
  final Widget? child;
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final String? backgroundImage;
  final bool isNetwork;
  final VoidCallback? onPressed;
  final bool? showBorder;
  final Color? borderColor;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: borderRadius != null
          ? BorderRadius.all(Radius.circular(borderRadius!))
          : null,
      child: Container(
        padding: padding,
        margin: margin,
        height: height,
        width: width,
        constraints: constraints,
        decoration: BoxDecoration(
            border: showBorder != null && showBorder!
                ? Border.all(color: borderColor ?? const Color(0xFF000000))
                : null,
            image: backgroundImage != null
                ? DecorationImage(
                    image: isNetwork
                        ? CachedNetworkImageProvider(backgroundImage!)
                        : AssetImage(backgroundImage!))
                : null,
            color: backgroundColor,
            borderRadius: borderRadius != null
                ? BorderRadius.all(Radius.circular(borderRadius!))
                : null),
        child: child,
      ),
    );
  }
}
