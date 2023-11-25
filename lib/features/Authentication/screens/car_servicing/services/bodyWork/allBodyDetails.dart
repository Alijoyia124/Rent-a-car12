import 'package:covid_tracker/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../../common widgets/round_button.dart';
import 'bookingPage/booking2.dart';
class allBodyDetails extends StatefulWidget {
  final String category;
  final String discount;
  final String serviceType;
  final String servicingOption;
  final String mainCategory;
  final String image; // Add this attribute
  final String description;
  final double hatchbackPrice;
  final double sedanPrice;
  final double crossoverPrice;


  const allBodyDetails({Key? key,
    required this.category,
    required this.mainCategory,
    required this.serviceType,
    required this.servicingOption,
    required this.hatchbackPrice,
    required this.sedanPrice,
    required this.crossoverPrice,
    // required this.cleaningPrice,
    required this.discount,
    required this.image,
    required this.description,
  }) : super(key: key);

  @override
  State<allBodyDetails> createState() => _allBodyDetailsState();
}

class _allBodyDetailsState extends State<allBodyDetails> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SingleChildScrollView(
          child: SafeArea(
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      decoration:const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity, // Set your desired width
                            height: double.infinity, // Set your desired height
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.image ?? ''), // Provide a default image URL
                                fit: BoxFit.fill, // You can use other BoxFit values like 'contain', 'fill', etc.
                              ),
                            ),
                          )
                          ,
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 20),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back_ios_new,color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Padding(padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:[
                                  Text(
                                      widget.category,
                                      style: Theme.of(context).textTheme.headline5!.copyWith(
                                          fontWeight: FontWeight.bold
                                      )
                                  ),

                                  // Text("Rs.${(widget.cleaningPrice) ?? "Default Price"}",style: Theme.of(context).textTheme.caption!.copyWith(
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 15
                                  // ),),
                                  // const   Text("Rs.30000",
                                  //   style: TextStyle(
                                  //     color:Colors.black,
                                  //     decoration: TextDecoration.lineThrough,
                                  //   ),)
                                ]),


                            const  SizedBox(height: 20,),
                            Row(
                                children: [
                                  RatingBar.builder(
                                    initialRating: 3.5, // The initial rating (can be any value)
                                    minRating: 1,      // Minimum rating
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,      // Number of stars
                                    itemSize: 25.0,    // Size of each star
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      // Handle the updated rating (e.g., send it to a server)
                                      print('Rated $rating stars!');
                                    },
                                  ),
                                  const  SizedBox(width: 5,),
                                  const  Text("(9)"),
                                ]
                            ) ,

                            const   SizedBox(height: 15,),
                            Text("Description",style: Theme.of(context).textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.bold
                            )),
                            Text("${widget.description ?? "Default description"}", style: Theme.of(context).textTheme.headline6!.copyWith(),
                              textAlign: TextAlign.justify,
                            ),

                            const SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.only(left: 50, right: 50),
                              child: RoundButton(
                                title: 'Book Now',
                                loading: false,
                                onPress: () {
                                  Get.to(
                                        () => BookingPage(
                                      category: widget.category,
                                          servicingOption:widget.servicingOption,
                                            mainCategory:widget.mainCategory,
                                      // cleaningPrice: widget.cleaningPrice,
                                      discount: widget.discount,
                                      image: widget.image,
                                      description: widget.description,
                                          serviceType: widget.serviceType,
                                          hatchbackPrice: widget.hatchbackPrice,
                                          sedanPrice:widget.sedanPrice,
                                            crossoverPrice: widget.crossoverPrice,
                                            pickupDateTime: DateTime.now()
                                    ),
                                    transition: Transition.fade,
                                    duration: const Duration(seconds: 1),
                                  );
                                },
                              ),
                            ),

                          ],
                        )
                    )
                  ]
              )
          ),
        )
    );
  }
}





