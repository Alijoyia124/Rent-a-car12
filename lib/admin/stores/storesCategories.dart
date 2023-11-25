import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'addStore.dart';
import 'allStores.dart';


class storesCategories extends StatefulWidget {
  const storesCategories({Key? key}) : super(key: key);



  @override
  State<storesCategories> createState() => _storesCategoriesState();
}

class _storesCategoriesState extends State<storesCategories> {final auth = FirebaseAuth.instance;
int numberOfBookedCars = 0; // Initialize to 0

Future<void> _refreshData() async {
  int count = await updateNumberOfBookedCars();
  setState(() {
    numberOfBookedCars = count;
  });
}

Future<int> calculateNumberOfBookedCars() async {
  try {
    // Reference to the Firestore collection
    CollectionReference bookedCarsCollection = FirebaseFirestore.instance.collection('booked_cars');

    // Get the documents in the collection
    QuerySnapshot querySnapshot = await bookedCarsCollection.get();

    // Calculate the number of documents (booked cars)
    int numberOfBookedCars = querySnapshot.docs.length;

    return numberOfBookedCars;
  } catch (e) {
    // Handle any errors (e.g., Firestore not available)
    print('Error calculating the number of booked cars: $e');
    return 0; // Return 0 in case of an error
  }
}

Future<int> updateNumberOfBookedCars() async {
  return calculateNumberOfBookedCars();
}

@override
void initState() {
  super.initState();
  _refreshData(); // Call _refreshData to initialize numberOfBookedCars
}

@override
Widget build(BuildContext context) {


  return Scaffold(
      appBar: AppBar(
        title: Text("All Cars"),
      ),
      body:
      RefreshIndicator(
        onRefresh: _refreshData,
        child:GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 40,
          mainAxisSpacing: 30,
          children: [

            itemDashboard(
              'All Stores',
              AssetImage('images/icons/tyre.png'), // Replace with your image asset
                  () {
                Get.to(()=> allStores(),transition:Transition.fade,duration: Duration(seconds: 1));
              },
            ),
            itemDashboard(
              'Add new Store',
              AssetImage('images/icons/tyre.png'), // Replace with your image asset
                  () {
                Get.to(()=> addStore(),transition:Transition.fade,duration: Duration(seconds: 1));
              },
            ),

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
