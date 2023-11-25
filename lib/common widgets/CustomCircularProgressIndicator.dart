import 'package:flutter/material.dart';
import 'package:covid_tracker/resources/color.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryMaterialColor),
    );
  }
}
