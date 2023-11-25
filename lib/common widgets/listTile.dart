import 'package:flutter/material.dart';

class listTile extends StatelessWidget {
  const listTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        scrollDirection: Axis.horizontal,
        children: [

          Container(
            padding: const EdgeInsets.all(10),
            width: 200,
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12, // Color of the shadow
                  spreadRadius: 2, // Spread radius
                  blurRadius: 2, // Blur radius
                  offset: Offset(2, 3), // Offset in the x, y direction
                ),
              ],//
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset("assets/images/workshop3.png"),
                ),
                const  Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Auto Care Center",
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Oil Change Service",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding:  EdgeInsets.only(left: 10), // Adjust left padding to move icons
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star_half,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            width: 200,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12, // Color of the shadow
                  spreadRadius: 2, // Spread radius
                  blurRadius: 2, // Blur radius
                  offset: Offset(2, 3), // Offset in the x, y direction
                ),
              ],),//
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset("assets/images/workshop2.png"),
                ),
                const Padding(
                  padding:  EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Deewan Car Center",
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Auto Repair Shop",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10), // Adjust left padding to move icons
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
    Container(
    padding: const EdgeInsets.all(10),
    width: 200,
      height: 250,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black12, // Color of the shadow
          spreadRadius: 2, // Spread radius
          blurRadius: 2, // Blur radius
          offset: Offset(2, 3), // Offset in the x, y direction
        ),
      ],//
      ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    ClipRRect(
    borderRadius: BorderRadius.circular(10),
      child: Image.asset("assets/images/workshop3.png"),
    ),
      const Padding(
    padding:  EdgeInsets.symmetric(
    vertical: 12,
    horizontal: 8,
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [  Text(
      "Auto Care Center",
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
    ),
      Text(
        "Oil Change Service",
        style: TextStyle(color: Colors.black),
      ),
    ],
    ),
    ),
      const Padding(
    padding:  EdgeInsets.only(left: 10), // Adjust left padding to move icons
    child: Row(
    children: [
    Icon(
    Icons.star,
    color: Colors.yellow,
    ),
    Icon(
    Icons.star,
    color: Colors.yellow,
    ),
    Icon(
    Icons.star,
    color: Colors.yellow,
    ),
    Icon(
    Icons.star_half,
    color: Colors.yellow,
    ),
    Icon(
    Icons.star_border,
    color: Colors.yellow,
    ),
    ],
    ),
    ),
    ],
    ),
    )]);
  }}
