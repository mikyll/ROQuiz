import 'package:flutter/material.dart';

class ConstrainedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double maxWidth;
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final double? elevation;
  final double? scrolledUnderElevation;

  @override
  late Size preferredSize;
  late AppBar appBar;

  ConstrainedAppBar({
    super.key,
    required this.maxWidth,
    this.title,
    this.leading,
    this.actions,
    this.elevation,
    this.scrolledUnderElevation,
  }) {
    appBar = AppBar(
      title: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) leading!,
            Spacer(),
            if (title != null) title!,
            Spacer(),
            if (leading != null) Opacity(opacity: 0.0, child: leading!),
          ],
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: actions,
    );
    preferredSize = appBar.preferredSize;
  }

  @override
  Widget build(BuildContext context) {
    return appBar;
  }
}
