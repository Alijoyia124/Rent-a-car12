import 'package:flutter/material.dart';

class reusableRow extends StatelessWidget {
  final String title, value;
  final IconData iconData;
  final Color? tileColor;
  final Color? iconColor; // New property for specifying the color of the icon

  const reusableRow({
    Key? key,
    required this.title,
    required this.iconData,
    required this.value,
    this.tileColor,
    this.iconColor, // Include it as an optional parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: Icon(
            iconData,
            color: iconColor, // Assign the color to the icon
          ),
          trailing: Text(value),
          tileColor: tileColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          dense: true,


        )
      ],
    );
  }
}
