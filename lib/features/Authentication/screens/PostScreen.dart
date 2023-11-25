import 'package:covid_tracker/common%20widgets/hover.dart';
import 'package:covid_tracker/features/Authentication/screens/Car Servicing.dart';
import 'package:covid_tracker/resources/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'car_rental/carRental.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final auth = FirebaseAuth.instance;

  final databaseref = FirebaseDatabase.instance.ref('txt');

  // Function to handle image click and navigation
  void navigateToPage(String imageTitle) {
    if (imageTitle == "Car Service") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CarService()));
    } else if (imageTitle == "Car Rental") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => carRental()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:const Text("Services",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: null,

        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HoverImage(
                      imageUrl:"assets/images/onboardingScreen/onboarding3.jpg",
                        imageTitle: "Car Service",
                      onTap: () {
                        Get.to(()=>const CarService(),transition:Transition.fade,duration: Duration(seconds: 1));
                      }),
                    const SizedBox(width: 10,),
                    HoverImage(
                        imageUrl:"assets/images/onboardingScreen/onboarding4.jpg",
                      imageTitle: "Car Rental",
                      onTap: (){
                           Get.to(()=>const carRental(),transition:Transition.fade,duration: Duration(seconds: 1));
                      } // Pass the onTap callback
                    ), ],
                ),
              )
            ])
    );
  }}