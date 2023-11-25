import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../resources/color.dart';

class bookedTyres extends StatefulWidget {
  const bookedTyres({Key? key}) : super(key: key);

  @override
  State<bookedTyres> createState() => _bookedTyresState();
}

class _bookedTyresState extends State<bookedTyres> {

  TextEditingController _carModelController = TextEditingController();
  TextEditingController _carManufacturerController = TextEditingController();
  TextEditingController _tyreSizeController = TextEditingController();
  TextEditingController _tyrePriceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();


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
    List<DocumentSnapshot> bookedTyresList = [];

    return Scaffold(
      appBar: AppBar(
        title: Text("All Tyres"),
      ),
     body:StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('booked_tyres').where('username', isEqualTo: username).snapshots(),
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

          bookedTyresList = snapshot.data!.docs; // Update the list

          return ListView.builder(
            itemCount: bookedTyresList.length,
            itemBuilder: (context, index) {
              final tyreDocument = bookedTyresList[index];
              final carData = tyreDocument.data() as Map<String, dynamic>;
              final carModel = carData['carModel'] ?? '';
              final carManufacturer = carData['carManufacturer'] ?? '';
              final tyreSize = carData['tyreSize'] ?? 0.0;
              final tyrePrice = carData['tyrePrice'] ?? 0.0;
              final discount = carData['discount'] ?? '';
              final category = carData['category'] ?? '';
              final description = carData['description'] ?? '';
              return Container(
                margin: EdgeInsets.fromLTRB(25, 11, 25, 11),
                height: 200,
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Brand Name:   $category',
                                        style: Theme.of(context).textTheme.headline6!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    IconButton(
                                      icon: FaIcon(FontAwesomeIcons.deleteLeft, size: 17, color: AppColors.primaryMaterialColor),
                                      onPressed: () async {
                                        // Show a confirmation dialog for delete
                                        final shouldDelete = await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Confirm Deletion'),
                                              content: Text('Are you sure you want to delete this tire?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: Text('CANCEL'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    // Update the UI list
                                                    setState(() {
                                                      bookedTyresList.removeAt(index);
                                                    });

                                                    // Delete the tire record if the user confirmed
                                                    await FirebaseFirestore.instance.collection('booked_tyres').doc(tyreDocument.id).delete();
                                                    Navigator.of(context).pop(true);
                                                  },
                                                  child: Text('DELETE'),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (shouldDelete == true) {
                                          // Delete the tire record if the user confirmed
                                          await FirebaseFirestore.instance.collection('booked_tyres').doc(tyreDocument.id).delete();
                                        }
                                      },
                                    ),

                                  ],
                                ),

                                SizedBox(height: 5),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:[
                                      Row(
                                          children:[
                                            Column(
                                                children:[
                                                  Text('Tyre Size',style: Theme.of(context).textTheme.caption!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),),
                                                  Text('$tyreSize'),
                                                ])]),
                                      Row(
                                          children:[
                                            Column(
                                                children:[
                                                  Text('Tyre Price',style: Theme.of(context).textTheme.caption!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15
                                                  ),),
                                                  Text('$tyrePrice'),


                                                ])]),
                                      Row(
                                          children:[
                                            Column(
                                                children:[
                                                  Text('Discount',style: Theme.of(context).textTheme.caption!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),),
                                                  Text('$discount'),
                                                ])]),

                                      // Text('Discount: $discount'),.................................;...;;.............................................................................................................
                                    ]),
                                SizedBox(height: 7,),

                              ])
                      )]),
              );

            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _carModelController.dispose();
    _carManufacturerController.dispose();
    _tyreSizeController.dispose();
    _tyrePriceController.dispose();
    _discountController.dispose();
    super.dispose();
  }
}
