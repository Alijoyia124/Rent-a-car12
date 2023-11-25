import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker/common%20widgets/sidebar_menu/sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../common widgets/rental_widgets/search.dart';
import '../../Controllers/FavoriteCar.dart';
import '../../Controllers/carController.dart';
import 'cardetails/detail_cars.dart';
import 'cardetails/favourites.dart';

class carRental extends StatefulWidget {
  const carRental({Key? key}) : super(key: key);

  @override
  _carRentalState createState() => _carRentalState();
}

class _carRentalState extends State<carRental> {
  String selectedBrand = ''; // Initialize with an empty string
  List<Car> carList = [];
  bool showCar = true;List<FavoriteCar> favoritesList = [];

  void toggleFavorite(String carId, bool isFavorite) async {
    // Check if the user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not logged in, show a message or redirect to the login page
      // You can customize this part based on your authentication logic
      return;
    }

    if (isFavorite) {
      final car = carList.firstWhere((element) => element.id == carId);

      // Add the car to the 'favorites1' collection along with listing data
      await FirebaseFirestore.instance.collection('favorites1').doc(user.uid).collection('cars').doc(carId).set({
        'name': car.name,
        'model': car.model,
        'manufacturer': car.manufacturer,
        'image': car.image,
        'description': car.description,
        'rentPerDay': car.rentPerDay,
        // Add other fields as needed
      });
    } else {
      // Remove the car from the 'favorites1' collection
      await FirebaseFirestore.instance.collection('favorites1').doc(user.uid).collection('cars').doc(carId).delete();
    }

    // Update the local state
    setState(() {
      if (isFavorite) {
        final car = carList.firstWhere((element) => element.id == carId);
        final favoriteCar = FavoriteCar(
          carId: car.id,
          name: car.name,
          model: car.model,
          manufacturer: car.manufacturer,
          image: car.image,
          description: car.description,
          rentPerDay: car.rentPerDay,
        );
        favoritesList.add(favoriteCar);

        // Show a SnackBar to indicate that the car has been added to favorites
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${car.name} added to favorites'),
          ),
        );
      } else {
        favoritesList.removeWhere((element) => element.carId == carId);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text("Rent a Car"),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LikedCarsPage(), // Replace with the actual name of your liked cars page
                    ),
                  );
                },
                icon: Icon(Icons.favorite),
              )
            ],
      ),
      drawer: sideBar(),
      backgroundColor: Color(0xFFf9ffff),
      body: SafeArea(
        child: Column(
          children: [
            // Inside the `Column` widget, above the car listings


            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text("All Brands",style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.bold
              ),),
                ElevatedButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CarSearch(carList), // Pass the carList to the search delegate
                    );
                  },
                  child:FaIcon(FontAwesomeIcons.search),
                ),
            ],),),
            SingleChildScrollView(
              scrollDirection:Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    CarFilterButton(
                      brand: 'All',
                      onTap: () {
                        filterCarsByBrand('All');
                      },
                      image: Image.asset('assets/logos/hondalogo.png'),
                    ),
                    SizedBox(width: 15,),
                    CarFilterButton(
                      brand: 'Honda',
                      onTap: () {
                        filterCarsByBrand('Honda');
                      },
                      image: Image.asset('assets/logos/hondalogo.png'),

                    ),
                    SizedBox(width: 15,),

                    CarFilterButton(
                      brand: 'Toyota',
                      onTap: () {
                        filterCarsByBrand('Toyota');
                      },
                      image: Image.asset('assets/logos/toyota1.png'),

                    ),
                    SizedBox(width: 15,),

                    CarFilterButton(
                      brand: 'Hyndai',
                      onTap: () {
                        filterCarsByBrand('hyndai');
                      },
                      image: Image.asset('assets/logos/hyndailogo.png'),

                    ),

                    SizedBox(width: 15,),

                    CarFilterButton(
                      brand: 'Suzuki',
                      onTap: () {
                        filterCarsByBrand('Suzuki');
                      },
                      image: Image.asset('assets/logos/suzuki1.png'),

                    ),
                    SizedBox(width: 15,),

                    CarFilterButton(
                      brand: 'KIA',
                      onTap: () {
                        filterCarsByBrand('KIA');
                      },
                      image: Image.asset('assets/logos/hondalogo.png'),

                      // Add more buttons for other car brands
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Top Deals",style: Theme.of(context).textTheme.caption!.copyWith(
                            fontWeight: FontWeight.bold,
                          fontSize: 15
                        )),
                        IconButton(
                          onPressed: () {
                            print("filter cars");
                          },
                          icon: Icon(Icons.sort),
                        ),
                      ],
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('addCarAdmin').snapshots(),
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
                              child: Text('No cars available.'),
                            );
                          }

                          final cars = snapshot.data!.docs.map((carDocument) {
                            final carData = carDocument.data() as Map<String, dynamic>;
                            final carId = carDocument.id; // Get the Firestore document ID
                            final carName = carData['carName'] ?? '';
                            final carModel = carData['carModel'] ?? '';
                            final carManufacturer = carData['carManufacturer'] ?? '';
                            final image = carData['image'] ?? '';
                            final description = carData['description'] ?? '';
                            final rentPerDay = carData['rentPerDay'] ?? '';



                            return Car(
                              id: carId, // Use the Firestore document ID as the unique identifier
                              name: carName,
                              model: carModel,
                              manufacturer: carManufacturer,
                              image: image,
                                description:description,
                                rentPerDay:rentPerDay,
                            );
                          }).toList();

                          carList = cars; // Update the carList with the fetched data

                              return ListView.builder(
    itemCount: carList.length,
    itemBuilder: (context, index) {
    final car = carList[index];
    if (selectedBrand.isNotEmpty && car.manufacturer.toLowerCase() != selectedBrand.toLowerCase()) {
    return Container(); // Return an empty container if the car doesn't match the selected brand
    }
    bool isFavorite = false; // You can manage the favorite state here.

    return ClipRRect(
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          elevation: 4.0,
          child: Stack(
            children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Image.network(
                                                car.image, // Use the imageUrl property from the Car object
                                                fit: BoxFit.cover,
                                                height: 250.0,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${car.name}',
                                                      style: Theme.of(context).textTheme.headline6!.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 2.0),
                                                    Text(
                                                      'Model: ${car.model}',
                                                      style: Theme.of(context).textTheme.caption!.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    // Text(
                                                    //   'Rent per Day: ${car.rentPerDay}',
                                                    //   style: Theme.of(context).textTheme.caption,
                                                    // ),
                                                    Text(
                                                      'Rent: ${car.rentPerDay}/day',
                                                      style: Theme.of(context).textTheme.caption,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
              Positioned(
                top: 6,
                right: 10,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite; // Toggle the favorite status
                        });

                        // Add or remove the car from the user's favorites list in Firestore
                        toggleFavorite(car.id, isFavorite);
                      },
                    )
                  ],
                ),
              ),


              Positioned(
                                          bottom: 2,
                                          right: 10,
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child:ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => CarDetailsPage(
                                                          carName: car.name,
                                                          carModel: car.model,
                                                          carManufacturer: car.manufacturer,
                                                          image: car.image,
                                                            description:car.description,
                                                          rentPerDay:car.rentPerDay,


                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                                    child: Text("Details"),
                                                  ),
                                                ),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void filterCarsByBrand(String brand) {
    setState(() {
      selectedBrand = brand;

      // If "All" is selected, show all cars
      if (brand == 'All') {
        selectedBrand = '';
      }
    });
  }}
class CarFilterButton extends StatelessWidget {
String selectedBrand = ''; // Initialize with an empty string

final String brand;
final Function onTap;
final Image image;

CarFilterButton({
  required this.brand,
  required this.onTap,
  required this.image,
});

// Define a height for the logo
final double buttonSize = 80.0;
final double logoPadding = 14.0;

@override
Widget build(BuildContext context) {
  return Container(
    width: buttonSize,
    height: buttonSize,
    margin: EdgeInsets.all(5), // Add margin for spacing
    child: GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white, // Set the container background color to white
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Color of the shadow
              spreadRadius: 2, // Spread radius
              blurRadius: 2, // Blur radius
              offset: Offset(0, 3),
            ),
          ],
        ),
        // Wrap the Image widget with a Container and set its height
        child: Padding(
          padding: EdgeInsets.all(logoPadding), // Add padding around the logo
          child: image,
        ),
      ),
    ),
  );
}
}
