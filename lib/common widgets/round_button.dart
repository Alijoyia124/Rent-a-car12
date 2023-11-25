import 'package:covid_tracker/resources/color.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {

  final String title;
  final VoidCallback onPress;
  final bool loading;

  const RoundButton({Key? key,
    required this.title,
  required this.onPress,
    this.loading=false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPress,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color:  AppColors.primaryMaterialColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(child: loading ?
        CircularProgressIndicator(strokeWidth:3,color: Colors.white):
        Text(title,style: Theme.of(context).textTheme.headline6!.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.white),),
      ),
      ));
  }
}
