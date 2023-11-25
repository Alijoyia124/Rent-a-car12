import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker/common%20widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../resources/color.dart';
import '../../../Controllers/bookingController.dart';
import 'bookingSuccessPage.dart';
class bookingSummary extends StatefulWidget {
  final String carName;
  final String carModel;
  final String carManufacturer;
  final String image;
  final String description;
  final double rentPerDay;
  final DateTime pickupDateTime;
  final DateTime returnDateTime;
  final String selectedShop;

  const bookingSummary({
    required this.carName,
    required this.carModel,
    required this.carManufacturer,
    required this.image,
    required this.description,
    required this.rentPerDay,
    required this.pickupDateTime,
    required this.returnDateTime,
    required this.selectedShop,
  });

  @override
  State<bookingSummary> createState() => _bookingSummaryState();
}

class _bookingSummaryState extends State<bookingSummary> {

  final firestore = FirebaseFirestore.instance;
  bool isBooking = false;
  final auth = FirebaseAuth.instance;

  User? user;
  String? userUID;
  String? username;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    if (user != null) {
      userUID = user!.uid;
      getUserUsername(user!.uid);
    }
  }
  Future<void> getUserUsername(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(
          userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          username = userData['username'] as String?;
        });
      }
    } catch (e) {
      print('Error retrieving username: $e');
    }
  }
  int calculateRentalDays() {
    if (widget.pickupDateTime == null || widget.returnDateTime == null) {
      return 0; // Handle cases where either pickup or return date is not selected.
    }

    final timeDifference = widget.returnDateTime.difference(widget.pickupDateTime);
    final hoursDifference = timeDifference.inHours;

    if (hoursDifference > 24) {
      // If the time difference is more than 24 hours, count it as an additional day.
      return timeDifference.inDays + 1;
    } else {
      return timeDifference.inDays;
    }
  }
  @override
  Widget build(BuildContext context) {
    final rentalDays = calculateRentalDays();
    final rent=rentalDays*widget.rentPerDay;
    return Scaffold(
      appBar: AppBar(
        title: Text("Summary"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10,30,10,20),
          child: SingleChildScrollView(
            child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Container(
                    height: 100,
                    width: 400,
                    decoration: BoxDecoration(
                      color:Colors.white70,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3), // Color of the shadow
                          spreadRadius: 3, // Spread radius
                          blurRadius: 4, // Blur radius
                          offset: Offset(0, 3), // Offset in the x, y direction
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      children: [
                        Image.network(
                          widget.image, // Use the imageUrl property from the Car object
                          fit: BoxFit.fill,
                          width: 200.0,
                        ),
                        SizedBox(width: 40),
                        Text(
                          '${widget.carName} \n ${widget.rentPerDay}/day',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white70, // Set the inner content color to black
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey), // Border color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3), // Color of the shadow
                      spreadRadius: 3, // Spread radius
                      blurRadius: 4, // Blur radius
                      offset: Offset(0, 3),// Adjust the spread radius as needed
                    ),
                  ],
                ),
              child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start, // Align the contents to the start (left)
                            children: [
                              Icon(FontAwesomeIcons.locationPinLock),
                              SizedBox(width: 8), // Adjust the width based on your preference
                              Text(
                                'Pick up Shop : ',
                                style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10 ),
                          Text(
                            ' ${widget.selectedShop}',
                          ),
                          SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start, // Align the contents to the start (left)
                            children: [
                              Icon(FontAwesomeIcons.solidClock,size: 18,),
                              SizedBox(width: 8), // Adjust the width based on your preference
                              Text(
                                'Pick up Date and Time : ',
                                style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10 ),
                          Text(
                            ' ${widget.pickupDateTime != null ? DateFormat('EEE, MMM d, y AT HH:mm a').format(widget.pickupDateTime!) : 'N/A'}',
                            ),
                          SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start, // Align the contents to the start (left)
                            children: [
                              Icon(FontAwesomeIcons.solidClock,size: 18,),
                              SizedBox(width: 8), // Adjust the width based on your preference
                              Text(
                                'Return Date and Time : ',
                                style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 5,),

                          Text(
                        ' ${widget.returnDateTime != null ? DateFormat('EEE, MMM d, y AT HH:mm a').format(widget.returnDateTime!) : 'N/A'}',

                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 60,),

              SizedBox(
                height: 5, // Adjust the height as needed
                child: Divider(
                  color: AppColors.primaryMaterialColor,
                ),
              ),
              Container(
                   margin: EdgeInsets.fromLTRB(18, 20, 18, 0),
                 child:Column(
                    children:[
                   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Per day Car Rent"),
                        Text('${widget.rentPerDay}'),
                      ],
                    ),
                   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Rental Days"),
                          Text('$rentalDays days'),
                        ],
                      ),
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Payment ",style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),),
                        Text('$rent',style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,)),
                      ],
                    ),


                  SizedBox(height:90 ),
    isBooking
    ? CircularProgressIndicator()
        : RoundButton(
    title: 'Confirm',
    onPress: () async {
      // Set isBooking to true to display the loading indicator
      setState(() {
        isBooking = true;
      });


      // Generate a unique booking ID
      String bookingId = DateTime.now().microsecondsSinceEpoch.toString();

      // Create a Booking object with the selected details
      final booking = Booking(
        bookingId: bookingId, // Assign the generated ID to the booking object
        carName: widget.carName,
        carModel: widget.carModel,
        selectedShop: widget.selectedShop,
        pickupDateTime: widget.pickupDateTime,
        returnDateTime: widget.returnDateTime,
        rent: rent,
        username: username ?? 'N/A',
        image: widget.image, // Add image URL to booking data
      );


      try {
        // Create a new document with a unique ID and set the booking data.
        await firestore.collection('booked_cars').doc(bookingId).set(booking.toMap());

        // If booking is successful, navigate to the next page.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                bookingSuccessPage(
                    carName: widget.carName, carModel: widget.carModel),
          ),
        );
      } catch (e) {
        // Handle any errors that may occur during the booking process.
        // You can display an error message here.
        print('Error: $e');
      } finally {
        // Set isBooking to false to hide the loading indicator.
        setState(() {
          isBooking = false;
        });
      }
    }
    )
    ],
    ),


              )]),
          )
        )

            ),

      );


  }
}
