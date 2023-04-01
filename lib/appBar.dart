import 'package:flutter/material.dart';

class AppBarIcon extends StatelessWidget with PreferredSizeWidget {
  AppBarIcon({Key? key, required this.actions, this.withBackButton = true})
      : super(key: key);
  final List<Widget> actions;
  final bool withBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      automaticallyImplyLeading: withBackButton,
      title: Image.asset('assets/mooLogo.png',
          fit: BoxFit.cover, height: 45, alignment: Alignment.bottomRight),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
