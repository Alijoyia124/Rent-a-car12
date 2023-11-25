
import 'dart:ui';
import 'package:covid_tracker/resources/color.dart';
import 'package:flutter/material.dart';

class HoverImage extends StatefulWidget {
  final String imageUrl;
  final String imageTitle;
  final Function() onTap;


  HoverImage({
    required this.imageUrl,
    required this.imageTitle,
    required this.onTap, // Receive the onTap callback
  });// Add an image title parameter

  @override
  _HoverImageState createState() => _HoverImageState();
}

class _HoverImageState extends State<HoverImage> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return  Container(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.7), // Color of the shadow
          spreadRadius: 2, // Spread radius
          blurRadius: 2, // Blur radius
          offset: Offset(5, 5), // Offset in the x, y direction
        ),
      ],// Adjust the border radius as needed
    ),
      child: Material(
        color: AppColors.primaryMaterialColor,
        elevation: 8,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: widget.onTap, // Call the onTap callback
          onHover: (hovered) {
            setState(() {
              isHovered = hovered;
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Ink.image(
                image: AssetImage(widget.imageUrl),
                height: 110,
                width: 150,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  widget.imageTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}