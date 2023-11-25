import 'package:covid_tracker/common%20widgets/Category.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget{
  final Category category;
  const Carousel({
    required this.category,
  });
  Widget build(BuildContext context){
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 5.0,vertical: 20),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.asset(
                  category.image,
                  fit: BoxFit.cover,
                  width: 1000.0),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration:const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    category.name,
                    style:Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.bold,

                      color: Colors.white,
                    )
                  ),
                ),
              ),
            ],
          )),
    );
  }
}