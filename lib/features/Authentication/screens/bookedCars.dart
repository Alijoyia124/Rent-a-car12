import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../resources/color.dart';

class bookedCars extends StatefulWidget {
  const bookedCars({Key? key}) : super(key: key);



  @override
  State<bookedCars> createState() => _bookedCarsState();
}
void deleteBooking(String documentId) {
  FirebaseFirestore.instance.collection('booked_cars').doc(documentId).delete();
}
Future<int> getNumberOfBookedCars() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('booked_cars').get();
  return snapshot.size; // This will return the number of documents in the collection.
}


void _showDeleteConfirmationDialog(BuildContext context, String documentId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete this record?"),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              // Close the dialog and delete the record
              deleteBooking(documentId);
              Navigator.of(context).pop();
            },
            child: Text("Yes"),
          ),
        ],
      );
    },
  );
}




class _bookedCarsState extends State<bookedCars> {
  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Booked Cars"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('booked_cars')
            .where('userId', isEqualTo: user!.uid) // Filter by the user's UID
            .snapshots(),
        builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
    return Center(child: Text('Error: ${snapshot.error}'));
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    return Center(child: Text('No bookings found.'));
    }

    return ListView(
    children: snapshot.data!.docs.map((document) {
    final data = document.data() as Map<String, dynamic>;

    final selectedShop = data['selectedShop'];
    final rent = data['rent'] ?? 0; // Fetch rent per day
    final documentId = document.id; // Get the Firestore document ID

    return Container(
    margin: EdgeInsets.fromLTRB(25, 11, 25, 11),
    height: 220,
    decoration: BoxDecoration(
    color:Colors.white70,
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.2), // Color of the shadow
    spreadRadius: 2, // Spread radius
    blurRadius: 2, // Blur radius
    offset: Offset(0, 3), // Offset in the x, y direction
    ),
    ],
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey),
    ),
    child: Column(
    children: [
    ListTile(
    title: Text(data['carName'], style: Theme.of(context).textTheme.headline6!.copyWith(
    fontWeight: FontWeight.bold,
    )),
    subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text("Model: ${data['carModel']}"),
    SizedBox(height: 5,),
    Row(children:[
    FaIcon(FontAwesomeIcons.locationPinLock,
    color: AppColors.primaryMaterialColor,),
    SizedBox(width: 5),
    Flexible(
    child: Text(" $selectedShop"),
    ),
    ]),
    SizedBox(height: 15),

    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Row(
    children: [
    Text("Rent Rate: \n $rent", style: Theme.of(context).textTheme.caption!.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 14
    )),
    ] ),

    ],
    ),

    ],
    ),
    trailing: GestureDetector(
    onTap: () {
    // Call the deleteBooking function when the delete icon is pressed
    deleteBooking(documentId);
    },
      child: GestureDetector(
        onTap: () {
          _showDeleteConfirmationDialog(context, documentId);
        },
        child: Icon(Icons.delete, color: AppColors.primaryMaterialColor),
      ),    ),
    // Add more widgets to display additional booking information.
    ),
    ],
    ),
    );
    }).toList(),
    );
    },
    ),
    );
  }
}
