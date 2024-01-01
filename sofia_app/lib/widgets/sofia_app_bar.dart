import 'package:flutter/material.dart';

class SofiaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const SofiaAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      notificationPredicate: (notification) => notification.depth == 1,
      scrolledUnderElevation: 4.0,
      shadowColor: Theme.of(context).shadowColor,
      elevation: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
