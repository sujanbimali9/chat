import 'package:flutter/material.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    super.key,
    this.backgroundColor,
    this.leading,
    this.title,
    this.centerTitle,
    this.toolbarHeight,
    this.actions,
    this.leadingWidth,
    this.showLeading = false,
  });

  final Widget? leading;
  final Color? backgroundColor;
  final Widget? title;
  final bool? centerTitle;
  final double? toolbarHeight;
  final List<Widget>? actions;
  final double? leadingWidth;
  final bool showLeading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: toolbarHeight,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.only(right: 8),
      child: AppBar(
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: showLeading,
        leadingWidth: leadingWidth,
        actions: actions,
        title: title,
        leading: leading,
        centerTitle: centerTitle,
        toolbarHeight: toolbarHeight,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight);
}
