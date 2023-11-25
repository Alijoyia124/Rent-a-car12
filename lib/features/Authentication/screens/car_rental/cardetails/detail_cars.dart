import 'package:covid_tracker/common%20widgets/round_button.dart';
import 'package:covid_tracker/resources/color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../common widgets/rental_widgets/TopMenuAndShowcase.dart';
import 'BookingInfomation.dart';


class CarDetailsPage extends StatefulWidget {
  final String carName;
  final String carModel;
  final String carManufacturer;
  final String image;
  final String description;
  final double rentPerDay;

  CarDetailsPage({
    required this.carName,
    required this.carModel,
    required this.carManufacturer,
    required this.image,
    required this.description,
    required this.rentPerDay,

  });

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  bool isExpanded = false;

  void toggleDescription() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey,
          ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
          width: double.infinity,
            height: 350,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 70,
                  right: 20,
                  left: 20,
                  bottom: 0,
                  child:Image.network(
                    widget.image, // Use the imageUrl property from the Car object
                    fit: BoxFit.fill,
                    width: 300.0,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 18, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 7,
                                      spreadRadius: 0.5)
                                ],
                              ),
                              child: Image.asset(
                                "assets/images/logos/ic_tesla_black.png",
                                width: 25,
                                height: 25,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.carName}',

                                  ),
                                  Text(
                                    '${widget.carModel}',
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
              ),
             const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                child: Text(
                  '${widget.carName}',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                child: Text(
                  'Specifications',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10,),

              Container(
                width: double.infinity,
                height: 100,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        padding:const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Max Power"),
                              Text("320 HP",style: Theme.of(context).textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.bold,)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        padding:const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Petrol Average"),
                              Text("15/16 km",style: Theme.of(context).textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.bold,)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        padding:const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Motor"),
                              Text("1300cc",style: Theme.of(context).textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.bold,)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                margin:const EdgeInsets.fromLTRB(20, 15, 0, 20),
                child: Text(
                  'Features',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                 child: Row(


                   children: [
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Add this line
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/logos/air-conditioner.png",
                            width: 50, // Specify the desired width
                            height: 30, // Specify the desired height
                          ),
                          SizedBox(width: 5), // Add some spacing between the image and text
                          Text(
                            'Air Conditioning',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 8), // Add some spacing between the image and text

                      Row(
                        children: [
                          Image.asset(
                            "assets/logos/user.png",
                            width: 50, // Specify the desired width
                            height: 30, // Specify the desired height
                          ),
                          SizedBox(width: 5), // Add some spacing between the image and text
                          Text(
                            '5 Seater',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 8), // Add some spacing between the image and text

                      Row(
                        children: [
                          Image.asset(
                            "assets/logos/tank-water.png",
                            width: 50, // Specify the desired width
                            height: 30, // Specify the desired height
                          ),
                          SizedBox(width: 5), // Add some spacing between the image and text
                          Text(
                            'Full Tank',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      )

                    ]  ),),

              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Add this line

                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/logos/music-alt.png",
                            width: 50, // Specify the desired width
                            height: 30, // Specify the desired height
                          ),
                          SizedBox(width: 5), // Add some spacing between the image and text
                          Text(
                            'Music',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 8), // Add some spacing between the image and text

                      Row(
                        children: [
                          Image.asset(
                            "assets/logos/bolt-auto.png",
                            width: 50, // Specify the desired width
                            height: 30, // Specify the desired height
                          ),
                          SizedBox(width: 5), // Add some spacing between the image and text
                          Text(
                            'Automatic',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),

                      // Add any other widgets related to the "Air Condition" category here
                    ],
                  ),
              ),
            ],
          ),
               ),


              Container(
                margin:const EdgeInsets.fromLTRB(20, 15, 0, 10),
                child: Text(
                  'Description : ',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                margin:const EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: isExpanded ? widget.description : (widget.description.length <= 100
                                ? widget.description
                                : (isExpanded
                                ? widget.description
                                : '${widget.description.substring(0, 100)}...')),
                            style:const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          if (widget.description.length > 100)
                            TextSpan(
                              text: isExpanded ? ' Read Less' : '...Read More',
                              style: TextStyle(
                                color: AppColors.primaryMaterialColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = toggleDescription,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

             Container(
                 margin:const EdgeInsets.fromLTRB(30, 20, 30, 10),

                 child: RoundButton(

                     title: 'Book Now', onPress: (){
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                       builder: (context) => CarRentalForm(
                         carName: widget.carName,
                         carModel: widget.carModel,
                         carManufacturer: widget.carManufacturer,
                         image: widget.image,
                         description: widget.description,
                         rentPerDay: widget.rentPerDay,
                         pickupDateTime: DateTime.now(),
                         returnDateTime: DateTime.now(),

                       )));
                 }))
            ])
          ),
        ));
  }
}

