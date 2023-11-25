import 'package:covid_tracker/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class tyresCategories extends StatefulWidget {
  const tyresCategories({Key? key}) : super(key: key);

  @override
  State<tyresCategories> createState() => _tyresCategoriesState();
}

class _tyresCategoriesState extends State<tyresCategories> {
  @override
  Widget build(BuildContext context) {
    return ImageSlideshow(
      indicatorColor: AppColors.primaryMaterialColor,
        indicatorBackgroundColor: Colors.white,
        height: 300,
        autoPlayInterval: 3000,
        indicatorRadius: 4,
        isLoop:true,
        children: [
          Padding(
              padding:const EdgeInsets.all(8),
              child: Image.asset("assets/images/tyres/tyre2.png")),
          Padding(
              padding:const EdgeInsets.all(8),
              child: Image.asset("assets/images/tyres/tyre3.png")),
          Padding(
              padding:const EdgeInsets.all(8),
              child: Image.asset("assets/images/tyres/tyre4.png")),
   ]
    );
  }
}

