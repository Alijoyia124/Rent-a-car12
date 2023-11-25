import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../common widgets/round_button.dart';

class addTyreAdmin extends StatefulWidget {
  const addTyreAdmin({Key? key}) : super(key: key);

  @override
  State<addTyreAdmin> createState() => _addTyreAdminState();
}

class _addTyreAdminState extends State<addTyreAdmin> {
  bool isSavingData = false;
  String? selectedCategory;
  String imageUrl='';

  List<String> tyreCategories = [
    'Pirelli',
    'Dunlop',
    'Michelin',
    'Yokohama',
    'Crown Tyres',
    'Service Tyres',
  ];

  final _formKey = GlobalKey<FormState>();
  TextEditingController _carModelController = TextEditingController();
  TextEditingController _carManufacturerController = TextEditingController();
  TextEditingController _tyreSizeController = TextEditingController();
  TextEditingController _tyrePriceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();




  void dispose() {
    super.dispose();
    _carModelController.dispose();
    _tyreSizeController.dispose();
    _carManufacturerController.dispose();
    _tyrePriceController.dispose();
    _discountController.dispose();
     _descriptionController.dispose();
  }
  // Initialize Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addTyreAdmin() async {

    // Get the car details from the text controllers
    String carModel = _carModelController.text;
    String carManufacturer = _carManufacturerController.text;
   String tyreSize = _tyreSizeController.text;
    double tyrePrice = double.parse(_tyrePriceController.text);
    String discount = _discountController.text;
    String description=_descriptionController.text;


    try {
      // Add the tire details to the "addTyreAdmin" collection in Firestore
      await _firestore.collection('addTyreAdmin').add({
        'carModel': carModel,
        'carManufacturer': carManufacturer,
        'tyreSize': tyreSize,
        'tyrePrice': tyrePrice,
        'discount': discount,
        'category': selectedCategory,
        'description':description,
        'image': imageUrl, // Add the image URL
      });
      await Future.delayed(const Duration(seconds: 2)); // Simulate a delay

      // After saving data, set the success state or error state
      // based on whether the operation was successful or not
      bool isSuccessful = true; // Change this based on the actual operation result

      if (isSuccessful) {
        print('Tyre data saved to Firestore.');

      } else {
        throw 'Error saving data'; // Throw an error to indicate a failure
      }
    }
    catch (e) {
      // Handle errors, e.g., show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding Tyre: $e'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Tyre"),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 40),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select a tire company', // Add your desired label text here
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              DropdownButton<String>(
                                value: selectedCategory,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCategory = newValue!;
                                    // Call a function to send the selected data to Firestore
                                    // sendSelectedCategoryToFirestore(newValue); // You can remove this line if not needed
                                  });
                                },
                                items: tyreCategories.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),

                          // TextFormField(
                          //   controller: _carModelController,
                          //   decoration: InputDecoration(labelText: 'Car Model'),
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please enter a car model';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          // TextFormField(
                          //   controller: _carManufacturerController,
                          //   decoration: InputDecoration(labelText: 'Car Manufacturer'),
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please enter the car manufacturer';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          TextFormField(
                            controller: _tyreSizeController,
                            decoration: InputDecoration(labelText: 'Tyre Size'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Tyre Size';
                              }
                              // You can add more validation for numeric input if needed
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _tyrePriceController,
                            decoration: InputDecoration(labelText: 'Tyre Price'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Tyre Price';
                              }
                              // You can add more validation for numeric input if needed
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _discountController,
                            decoration: InputDecoration(labelText: 'Tyre Discount'),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Tyre Discount';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(labelText: 'Description of Tyre'),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Tyre Description';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              ImagePicker imagePicker = ImagePicker();
                              XFile? file= await imagePicker.pickImage(source: ImageSource.gallery);
                              print('${file?.path}');

                              if(file==null)return;

                              String uniqueFileName=DateTime.now().millisecondsSinceEpoch.toString();

                              Reference referenceRoot=FirebaseStorage.instance.ref();
                              Reference referenceDirImages=referenceRoot.child('images/cleaning');

                              Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);

                              try {
                                await referenceImageToUpload.putFile(File(file!.path));
                                imageUrl =await referenceImageToUpload.getDownloadURL();
                              }
                              catch(error){

                              }



                            },
                            child: Text("Slct Imag"),
                          ),

                          if (isSavingData)
                            Center(
                              child: CircularProgressIndicator(),
                            )
                          else
                            RoundButton(
                                title: 'Add Tyre',
                                onPress: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // Set isSavingData to true to show a loading indicator
                                    setState(() {
                                      isSavingData = true;
                                    });

                                    // Call the function to save car data
                                    await addTyreAdmin().then((_) {
                                      // Data has been successfully saved
                                      print('Car data saved to Firestore successfully.');


                                    }).catchError((error) {
                                      // Handle any errors that may occur during the data-saving process
                                      print('Error saving tyre data: $error');

                                      // Show an error message in a dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content: Text(
                                                'An error occurred while saving the Tyre data: $error'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }).whenComplete(() {
                                      // Set isSavingData back to false after the operation is complete
                                      setState(() {
                                        isSavingData = false;
                                      });
                                      _carModelController.clear();
                                      _carManufacturerController.clear();
                                      _tyreSizeController.clear();
                                      _tyrePriceController.clear();
                                      _discountController.clear();
                                      _descriptionController.clear() ;
                                      // Show a popup dialog for success
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Success',style: Theme.of(context).textTheme.headline5!.copyWith(
                                                fontWeight: FontWeight.bold
                                            ),),
                                            content: Text('Tyre added successfully!'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    });
                                  }}
                            )
                        ])
                ))));
  }}
