import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../resources/color.dart';

class bookedAdmin extends StatefulWidget {
  const bookedAdmin({Key? key}): super(key: key);

  @override
  State<bookedAdmin> createState() => _bookedAdminState();
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
class _bookedAdminState extends State<bookedAdmin> {
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
              final pickupDate = data['pickupDateTime'] as Timestamp?;
              final returnDate = data['returnDateTime'] as Timestamp?;
              final username=data['username'];
              final documentId = document.id; // Get the Firestore document ID

              return Container(
                margin: EdgeInsets.fromLTRB(6, 11, 6, 11),
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(data['carName'],
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Booked By : $username",
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(children: [
                            FaIcon(FontAwesomeIcons.locationPinLock,
                                color: AppColors.primaryMaterialColor),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(" $selectedShop"),
                            ),
                          ]),
                          Column(
                            children: [
                              Text(
                                "Rent\n $rent",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  children: [
                                    Text(
                                      "Pickup Date\n${pickupDate != null ? DateFormat('EEE, MMM d ,HH:mm a').format(pickupDate.toDate()) : 'N/A'}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    )]),
                              SizedBox(width: 3,),
                              Column(
                                children: [
                                  Text(
                                    "Return Date\n${returnDate != null ? DateFormat('EEE, MMM d ,HH:mm a').format(returnDate.toDate()) : 'N/A'}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),


                            ],
                          )
                        ],
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          // Call the deleteBooking function when the delete icon is pressed
                          deleteBooking(documentId);
                        },
                        child: FaIcon(FontAwesomeIcons.deleteLeft,
                            color: AppColors.primaryMaterialColor),
                      ),
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