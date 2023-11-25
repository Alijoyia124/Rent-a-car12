import 'package:covid_tracker/resources/color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Car Servicing.dart';
import '../../../../car_rental/cardetails/allBookingcars.dart';


class bookingSuccess  extends StatelessWidget {
  const bookingSuccess ({Key? key,}) : super(key: key);

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
                SizedBox(height: 12),
                Container(
                    child: RichText(
                      text: TextSpan(

                        children: <TextSpan>[
                          TextSpan(
                            text: " Congratulations ! you have booked successfully . ",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "  Go to my booking to view your  ",
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
                                      builder: (context) => allBookings())
                                );
                              },
                          ),
                        ],
                      ),
                    )
                ),
                SizedBox(height: 200,),
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

