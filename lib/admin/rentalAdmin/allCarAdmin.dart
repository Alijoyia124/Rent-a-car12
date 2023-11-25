import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllCarAdmin extends StatefulWidget {
  @override
  _AllCarAdminState createState() => _AllCarAdminState();
}

class _AllCarAdminState extends State<AllCarAdmin> {
  TextEditingController carNameController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController carManufacturerController = TextEditingController();
  TextEditingController petrolAverageController = TextEditingController();
  TextEditingController rentPerDayController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _editCarDetails(String carId) async {
    final shouldEdit = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Car Details'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: carNameController,
                  decoration: InputDecoration(labelText: 'Car Name'),
                ),
                TextFormField(
                  controller: carModelController,
                  decoration: InputDecoration(labelText: 'Car Model'),
                ),
                TextFormField(
                  controller: carManufacturerController,
                  decoration: InputDecoration(labelText: 'Car Manufacturer'),
                ),
                TextFormField(
                  controller: petrolAverageController,
                  decoration: InputDecoration(labelText: 'Petrol Average'),
                ),
                TextFormField(
                  controller: rentPerDayController,
                  decoration: InputDecoration(labelText: 'Rent per Day'),
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
      final carRef = FirebaseFirestore.instance.collection('addCarAdmin').doc(carId);
      await carRef.update({
        'carName': carNameController.text,
        'carModel': carModelController.text,
        'carManufacturer': carManufacturerController.text,
        'petrolAverage': double.parse(petrolAverageController.text),
        'rentPerDay': double.parse(rentPerDayController.text),
        'description': descriptionController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Cars',
          style: Theme.of(context).textTheme.headline5!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
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

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final carDocument = snapshot.data!.docs[index];
              final carData = carDocument.data() as Map<String, dynamic>;
              final carName = carData['carName'] ?? '';
              final carModel = carData['carModel'] ?? '';
              final carManufacturer = carData['carManufacturer'] ?? '';
              final petrolAverage = carData['petrolAverage'] ?? 0.0;
              final rentPerDay = carData['rentPerDay'] ?? 0.0;
              final description = carData['description'] ?? '';
              final image = carData['image'] ?? ''; // Assuming you store the image URL in Firestore

              return ClipRRect(
                borderRadius: BorderRadius.circular(40.0), // Adjust the value to control the roundness
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Display the car image at the top of the card
                      Image.network(
                        image,
                        fit: BoxFit.cover,
                        height: 180.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Car Name: $carName',
                                  style: Theme.of(context).textTheme.headline6!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        // Pre-fill the edit form with existing details
                                        carNameController.text = carName;
                                        carModelController.text = carModel;
                                        carManufacturerController.text = carManufacturer;
                                        petrolAverageController.text = petrolAverage.toString();
                                        rentPerDayController.text = rentPerDay.toString();
                                        descriptionController.text = description;

                                        // Call the _editCarDetails function
                                        _editCarDetails(carDocument.id);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
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
                                                  onPressed: () => Navigator.of(context).pop(true),
                                                  child: Text('DELETE'),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (shouldDelete == true) {
                                          // Delete the car record if the user confirmed
                                          await FirebaseFirestore.instance.collection('addCarAdmin').doc(carDocument.id).delete();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0), // Add some spacing between Car Name and other details
                            Text('Car Model: $carModel', style: Theme.of(context).textTheme.caption!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),),
                            Text('Car Manufacturer: $carManufacturer'),
                            Text('Petrol Average: $petrolAverage'),
                            Text('Rent per Day: $rentPerDay'),
                            Text('Description: $description'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    carNameController.dispose();
    carModelController.dispose();
    carManufacturerController.dispose();
    petrolAverageController.dispose();
    rentPerDayController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
