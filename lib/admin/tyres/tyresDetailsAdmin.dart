import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'TyreOrdersList.dart';
import 'addTyreAdmin.dart';
import 'allAddedTyres.dart';

class TyresDetailsAdmin extends StatefulWidget {
  const TyresDetailsAdmin({Key? key}) : super(key: key);

  @override
  State<TyresDetailsAdmin> createState() => _TyresDetailsAdminState();
}

class _TyresDetailsAdminState extends State<TyresDetailsAdmin> {
  final auth = FirebaseAuth.instance;

  // List to store the orders retrieved from Firebase
  List<Map<String, dynamic>> orders = [];

  // List to store the products retrieved from Firebase
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    // Call the methods to retrieve orders and products when the widget initializes
    retrieveOrders();
    retrieveProducts();
  }

  // Method to retrieve orders from Firebase
  void retrieveOrders() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('booked_tyres') // Replace with your 'tyres' collection name
          .get();

      // Iterate through the documents and store them in the orders list
      orders = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      // Update the UI
      setState(() {});
    } catch (e) {
      // Handle any errors here
      print('Error retrieving orders: $e');
    }
  }

  // Method to retrieve products from Firebase
  void retrieveProducts() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products') // Replace with your 'products' collection name
          .get();

      // Iterate through the documents and store them in the products list
      products = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      // Update the UI
      setState(() {});
    } catch (e) {
      // Handle any errors here
      print('Error retrieving products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tyre Orders"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 40,
          mainAxisSpacing: 30,
          children: [

            itemDashboard(
              'Tyre Orders',
              AssetImage('images/icons/tyre.png'), // Replace with your image asset
                  () {
    // Navigate to the Orders page
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => TyreOrdersList(orders: orders), // Pass the orders to the new page
    ),
    );
    } ),

    itemDashboard(
    'Add New Tyres',
    AssetImage('images/icons/tyre.png'), // Replace with your image asset
    () {
    // Navigate to the Orders page
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => addTyreAdmin(), // Pass the orders to the new page
    ));
    }
    ), itemDashboard(
                'All Tyres',
                AssetImage('images/icons/tyre.png'), // Replace with your image asset
                    () {
                  // Navigate to the Orders page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => allTyresAdmin(), // Pass the orders to the new page
                      ));
                }
            )
          ],
      ),
    ));
  }



  itemDashboard(String title, ImageProvider<Object> imageProvider, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image(
                image: imageProvider,
                width: 50,
                height: 60,
              ),
            ),
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.caption!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
