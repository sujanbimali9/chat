import 'package:flutter/material.dart';

class TSocialMediaButton extends StatelessWidget {
  const TSocialMediaButton(
      {super.key,
      required this.icon,
      this.height,
      this.width,
      this.onPressed,
      this.showBorder = false,
      this.iconColor,
      this.borderColor});
  final String icon;
  final double? height;
  final double? width;
  final bool showBorder;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        height: height ?? 40,
        width: width ?? 40,
        decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular((height) ?? 40))),
        child: Image.asset(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
