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
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  if (title != null)
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: title!,
                      ),
                    ),
                  if (leading != null) Positioned(left: -10, child: leading!),
                  if (actions != null)
                    Positioned(right: -10, child: Row(children: actions!)),
                ],
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
    preferredSize = appBar.preferredSize;
  }

  @override
  Widget build(BuildContext context) {
    return appBar;
  }
}
