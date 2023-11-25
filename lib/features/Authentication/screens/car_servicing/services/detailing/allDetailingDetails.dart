import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../../common widgets/round_button.dart';
import '../bodyWork/bookingPage/booking.dart';
class allDetailingDetails extends StatefulWidget {
  final double hatchbackPrice;
  final double sedanPrice;
  final double crossoverPrice;
  final String discount;
  final String image;
  final String serviceType;
  final String servicingOption;
  final String description;
  final String mainCategory;


  const allDetailingDetails({Key? key,
    required this.hatchbackPrice,
    required this.sedanPrice,
    required this.crossoverPrice,
    required this.discount,
    required this.image,
    required this.serviceType,
    required this.servicingOption,
    required this.description,
    required this.mainCategory,

  }) : super(key: key);

  @override
  State<allDetailingDetails> createState() => _allDetailingDetailsState();
}

class _allDetailingDetailsState extends State<allDetailingDetails> {


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
                                      widget.servicingOption,
                                      style: Theme.of(context).textTheme.headline5!.copyWith(
                                          fontWeight: FontWeight.bold
                                      )
                                  ),

                                  Text("Rs.${(widget.sedanPrice) ?? "Default Price"}",style: Theme.of(context).textTheme.caption!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                  ),),
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
                              padding: const EdgeInsets.only(left: 50,right: 50),
                              child: RoundButton(title: 'Book Now',
                                  loading: false,
                                  onPress: () {
                                    Get.to(()=>bodyBookingPage(
                                        servicingOption: widget.servicingOption,
                                        serviceType:widget.serviceType,
                                        hatchbackPrice: widget.hatchbackPrice,
                                        sedanPrice:widget.sedanPrice,
                                        crossoverPrice: widget.crossoverPrice,
                                        mainCategory:widget.mainCategory,
                                        pickupDateTime: DateTime.now()
                                    ),transition:Transition.fade,duration: const Duration(seconds: 1));
                                  }
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





