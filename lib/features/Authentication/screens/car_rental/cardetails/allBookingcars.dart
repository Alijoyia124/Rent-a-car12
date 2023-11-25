import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../../resources/color.dart';

class allBookings extends StatefulWidget {
  allBookings({Key? key}) : super(key: key);

  @override
  State<allBookings> createState() => _allBookingsState();
}

class _allBookingsState extends State<allBookings> {

  // Add this inside _allBookingsState class

  final favoritesCollection = FirebaseFirestore.instance.collection('favorites');

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

  void deleteBooking(String documentId) {
    FirebaseFirestore.instance.collection('booked_cars').doc(documentId).delete();

    // Remove from favorites collection as well
    favoritesCollection.doc(documentId).delete();
  }

  Future<void> addToFavorites(String documentId) async {
    try {
      await favoritesCollection.doc(documentId).set({
        'userId': userUID,
        // Add other necessary data from the booking
      });
    } catch (e) {
      print('Error adding to favorites: $e');
    }
  }


  Future<void> _showDeleteConfirmationDialog(String documentId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you really want to delete this booking?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                deleteBooking(documentId); // Call the deleteBooking function
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Bookings"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('booked_cars')
            .where('username', isEqualTo: username) // Filter by username
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
              final documentId = document.id; // Get the Firestore document ID
              final imageUrl = data['imageUrl']; // Replace 'imageUrl' with the actual key

              return Container(
                margin: EdgeInsets.fromLTRB(12, 15, 12, 15),
                height: 320,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 8),
                    child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                if (imageUrl != null)
                                  Image.network(
                                    imageUrl,
                                    width: 120, // Adjust the width as needed
                                    height: 90, // Adjust the height as needed
                                    fit: BoxFit.cover,
                                  )
                                else
                                  SizedBox.shrink(),
                                SizedBox(width: 18),
                                Column(
                                    children: [
                                  Text(
                                    data['carName'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                            Text(
                                                'Booking ID: ${documentId.substring(
                                                  documentId.length - 5,
                                                  documentId.length,
                                                )}',
                                            )]),
              ]),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30),
                            Row(children:[
                              FaIcon(FontAwesomeIcons.locationPinLock,
                                  color: AppColors.primaryMaterialColor),
                              SizedBox(width: 5),
                              Flexible(
                                child: Text(" $selectedShop"),
                              ),
                            ]),
                            SizedBox(height: 5),
                            Column(
                              children: [
                                Text(
                                  "Rent : $rent",
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
                            ),
                          ],
                        ),
    trailing: GestureDetector(
    onTap: () {
    // Show the delete confirmation dialog when the delete icon is pressed
    _showDeleteConfirmationDialog(documentId);
    },
    child: FaIcon(FontAwesomeIcons.deleteLeft,
    color: AppColors.primaryMaterialColor),
    ),
    )]),
                  ));
    }).toList(),
    );
    },
    ));
  }
}