import 'package:flutter/material.dart';

class CircleAvatarWidget extends StatelessWidget {
  final String text;
  final String imagePath;
  final double radius;
  final Color textColor;



  const CircleAvatarWidget({

    required this.text,
    required this.imagePath,
    this.radius = 30,
    this.textColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5.0,
                  offset: Offset(0,2),
                  ),

    ]),



         child: CircleAvatar(
            radius: radius,
            backgroundImage: AssetImage(imagePath),
            backgroundColor: Colors.white,
)
          ),
      SizedBox(height: 4),
          Text(
            text,
          ),
         // Add some spacing between the image and text

        ],
      ),
    );
  }
}
