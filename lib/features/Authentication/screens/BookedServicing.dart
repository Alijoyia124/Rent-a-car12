import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../resources/color.dart';

class bookedServicing extends StatefulWidget {
  const bookedServicing({Key? key}) : super(key: key);

  @override
  State<bookedServicing> createState() => _bookedServicingState();
}

class _bookedServicingState extends State<bookedServicing> {
  TextEditingController _cleaningPriceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _editTyreDetails(String carId) async {
    final shouldEdit = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Car Details'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _cleaningPriceController,
                  decoration: InputDecoration(labelText: 'Cleaning Price'),
                ),
                TextFormField(
                  controller: _discountController,
                  decoration: InputDecoration(labelText: 'Discount'),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('SAVE'),
            ),
          ],
        );
      },
    );

    if (shouldEdit == true) {
      // Update the car details in Firebase
      final carRef = FirebaseFirestore.instance.collection('addCleaningAdmin').doc(carId);
      await carRef.update({
        'cleaningPrice': double.parse(_cleaningPriceController.text),
        'discount': _discountController.text,
      });
    }
  }

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
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Booked Cleaning Services"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bookings').where('username', isEqualTo: username).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final tyreDocument = snapshot.data!.docs[index];
              final carData = tyreDocument.data() as Map<String, dynamic>;

              final servicingOption = carData['servicingOption'];
              final description = carData['description'];
              final image = carData['image'];

              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(25, 11, 25, 11),
                    height: 300,
                    width: double.infinity,
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 70,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(image),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '$servicingOption',
                                    style: Theme.of(context).textTheme.headline6!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        children: [],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                'Description:',
                                style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text('$description'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 22,
                    child: Row(
                      children: [
                        IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.edit,
                            size: 17,
                            color: AppColors.primaryMaterialColor,
                          ),
                          onPressed: () {
                            // Pre-fill the edit form with existing details
                            descriptionController.text = description != null ? description : '';
                            // Call the _editCarDetails function
                            _editTyreDetails(tyreDocument.id);
                          },
                        ),
                        IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.deleteLeft,
                            size: 17,
                            color: AppColors.primaryMaterialColor,
                          ),
                          onPressed: () async {
                            // Show a confirmation dialog for delete
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Deletion'),
                                  content: Text('Are you sure you want to delete this car?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: Text('CANCEL'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Delete the tire record if the user confirmed
                                        await FirebaseFirestore.instance.collection('addCleaningAdmin').doc(tyreDocument.id).delete();
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text('DELETE'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (shouldDelete == true) {
                              // Delete the car record if the user confirmed
                              await FirebaseFirestore.instance.collection('addCleaningAdmin').doc(tyreDocument.id).delete();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    _cleaningPriceController.dispose();
    _discountController.dispose();
    super.dispose();
  }
}
