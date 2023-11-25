import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../resources/color.dart';
import '../../../Controllers/FavoriteCar.dart';
import '../../../Controllers/carController.dart';

class LikedCarsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is not logged in, show a message or redirect to the login page
      // You can customize this part based on your authentication logic
      return Center(
        child: Text('Please log in to view liked listings.'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Listings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('favorites1')
            .doc(user.uid)
            .collection('cars')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No liked listings.'),
            );
          }

          final likedCars = snapshot.data!.docs.map((carDocument) {
            final carData = carDocument.data() as Map<String, dynamic>;

            // Create a Car object from the data
            final car = Car(
              id: carDocument.id,
              name: carData['name'] ?? '',
              model: carData['model'] ?? '',
              manufacturer: carData['manufacturer'] ?? '',
              image: carData['image'] ?? '',
              description: carData['description'] ?? '',
              rentPerDay: carData['rentPerDay'] ?? '',
            );

            return car;
          }).toList();

          return ListView.builder(
            itemCount: likedCars.length,
            itemBuilder: (context, index) {
              final car = likedCars[index];

              return Dismissible(
                key: Key(car.id),
                background: Container(
                  color: Colors.red,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  // Remove the car from the user's favorites list and the database
                  removeFavoriteCar(car.id);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(12, 10, 12, 4),
                  height: 170,
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
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              if (car.image != null)
                                Image.network(
                                  car.image,
                                  width: 120, // Adjust the width as needed
                                  height: 70, // Adjust the height as needed
                                  fit: BoxFit.cover,
                                )
                              else
                                SizedBox.shrink(),
                              SizedBox(width: 18),
                              Column(
                                children: [
                                  Text(
                                    car.name,
                                    style: Theme.of(context).textTheme.headline5!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Model: ${car.model}"),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SizedBox(height: 8,),
                                  Text("RentPerDay", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                                  Text("${car.rentPerDay}/day", style: Theme.of(context).textTheme.caption),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 8,),
                                  Text("RentPerDay", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                                  Text("${car.rentPerDay}/day", style: Theme.of(context).textTheme.caption),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void removeFavoriteCar(String carId) {
    final user = FirebaseAuth.instance.currentUser;

    // Remove the car from the 'favorites1' collection
    FirebaseFirestore.instance.collection('favorites1').doc(user!.uid).collection('cars').doc(carId).delete();
  }
}
