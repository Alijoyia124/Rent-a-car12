import 'package:covid_tracker/resources/color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Car Servicing.dart';
import '../../../car_rental/cardetails/allBookingcars.dart';

class cleaningSuccessPage extends StatelessWidget {
  final String carType;
  final String carBrand;
  final String carModel;
  final String carName;
  final int? selectedYear;
  final String serviceType;
  final String servicingOption;
  final double price;
  final String phone;
  final DateTime pickupDateTime;
  final String mainCategory;


  const cleaningSuccessPage({Key? key, required this.carType,
    required this.carBrand,
    required this.carModel,
    required this.carName,
    required this.mainCategory,
    required this.selectedYear,
    required this.serviceType,
    required this.servicingOption,
    required this.price,
    required this.pickupDateTime,
    required this.phone, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(30, 10, 30, 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/logos/cloud-check.png",
                  height:150,
                  width: 120,
                ),
                Text("Booked Successfully",style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primaryMaterialColor
                )),
                const SizedBox(height: 12),
                Container(
                    child: RichText(
                      text: TextSpan(

                        children: <TextSpan>[
                          TextSpan(
                            text: " Congratulations ! you have booked ($servicingOption for $carName $selectedYear ) successfully .",
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                          const TextSpan(
                            text: " Go to my booking to view your  ",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,

                            ),
                          ),
                          TextSpan(
                            text: "Bookings",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color:AppColors.primaryMaterialColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return allBookings();
                                    },
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    )
                ),
                const SizedBox(height: 200,),
                Container(
                  height: 50,
                  width: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60)
                  ),
                  child: ElevatedButton(

                      onPressed:(){
                        Get.to(()=> CarService(),transition:Transition.fade,duration: Duration(seconds: 1));

                      },
                      child: Text("Back to Home",style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 16,color: Colors.white
                      ),)),
                )


              ]),
        ),
      ),
    );

  }
}
