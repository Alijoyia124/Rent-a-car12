import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../admin/cleaning/allAddedCleaning.dart';
import '../../../common widgets/CustomCircularProgressIndicator.dart';
import 'BookedServicing.dart';
import 'bookedTyres.dart';
import 'car_rental/cardetails/allBookingcars.dart';
import 'car_servicing/services/bodyWork/bodyWork.dart';

class Mybookings extends StatefulWidget {
  const Mybookings({Key? key}) : super(key: key);
  @override
  State<Mybookings> createState() => _MybookingsState();
}

class _MybookingsState extends State<Mybookings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Bookings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildBookingContainer(
              title: "Booked Cars",
              destinationPage: allBookings(),
            ),

            buildBookingContainer(
              title: "Booked Tyres",
              destinationPage: bookedTyres(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBookingContainer({
    required String title,
    required Widget destinationPage,
  }) {
    return GestureDetector(
      onTap: () async {
        // Show a circular indicator while navigating
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CustomCircularProgressIndicator(
              ),
            );
          },
        );

        // Simulate some asynchronous operation (e.g., fetching data)
        // Replace this with your actual asynchronous operation
        await Future.delayed(Duration(seconds: 3));

        // Dismiss the dialog
        Navigator.of(context).pop();

        // Navigate to the desired page here after the indicator is dismissed
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return destinationPage;
        }));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Icon(FontAwesomeIcons.angleRight, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
