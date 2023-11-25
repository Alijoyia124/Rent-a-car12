import 'package:flutter/material.dart';

class MyGradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;

  const MyGradientAppBar({Key? key, required this.height, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffB81736), Color(0xff281537)],
        ),
      ),
      child: AppBar(
        title: Text(
          title,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
