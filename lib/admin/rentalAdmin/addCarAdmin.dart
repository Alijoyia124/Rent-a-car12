import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../common widgets/round_button.dart';

class addCarAdmin extends StatefulWidget {
  const addCarAdmin({Key? key}) : super(key: key);

  @override
  State<addCarAdmin> createState() => _addCarAdminState();
}

class _addCarAdminState extends State<addCarAdmin> {
  bool isSavingData = false;
  String imageUrl='';


  final _formKey = GlobalKey<FormState>();
  TextEditingController _carNameController = TextEditingController();
  TextEditingController _carModelController = TextEditingController();
  TextEditingController _carManufacturerController = TextEditingController();
  TextEditingController _petrolAverageController = TextEditingController();
  TextEditingController _rentPerDayController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();



  void dispose() {
    super.dispose();
    _carNameController.dispose();
    _carModelController.dispose();
    _carManufacturerController.dispose();
    _petrolAverageController.dispose();
    _rentPerDayController.dispose();
    _descriptionController.dispose();
  }
  // Initialize Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addCar() async {
    // Get the car details from the text controllers
    String carName = _carNameController.text;
    String carModel = _carModelController.text;
    String carManufacturer = _carManufacturerController.text;
    double petrolAverage = double.parse(_petrolAverageController.text);
    double rentPerDay = double.parse(_rentPerDayController.text);
    String description = _descriptionController.text;
    try {
      if (imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please upload an image")),
        );
      }
      else {
        // Add the car details to the "addCarAdmin" collection in Firestore
      await _firestore.collection('addCarAdmin').add({
        'carName': carName,
        'carModel': carModel,
        'carManufacturer': carManufacturer,
        'petrolAverage': petrolAverage,
        'rentPerDay': rentPerDay,
        'description': description,
        'image': imageUrl, // Add the image URL
      });

      // Reset the form
      _carNameController.clear();
      _carModelController.clear();
      _carManufacturerController.clear();
      _petrolAverageController.clear();
      _rentPerDayController.clear();
      _descriptionController.clear();
      imageUrl = ''; // Reset imageUrl

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Success',
              style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text('Car Added Successfully'),
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
      }
    } catch (e) {
      // Handle errors, e.g., show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding New Car: $e'),
        ),
      );
    } finally {
      // Regardless of success or error, set isSavingData to false here
      setState(() {
        isSavingData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Car"),
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
                TextFormField(
                  controller: _carNameController,
                  decoration: InputDecoration(labelText: 'Car Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a car name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _carModelController,
                  decoration: InputDecoration(labelText: 'Car Model'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a car model';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _carManufacturerController,
                  decoration: InputDecoration(labelText: 'Car Manufacturer'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the car manufacturer';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _petrolAverageController,
                  decoration: InputDecoration(labelText: 'Petrol Average'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter petrol average';
                    }
                    // You can add more validation for numeric input if needed
                    return null;
                  },
                ),
                TextFormField(
                  controller: _rentPerDayController,
                  decoration: InputDecoration(labelText: 'Rent per Day'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter rent per day';
                    }
                    // You can add more validation for numeric input if needed
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description of Car'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Car Description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file= await imagePicker.pickImage(source: ImageSource.gallery);
                    print('${file?.path}');

                    if(file==null)return;

                    String uniqueFileName=DateTime.now().millisecondsSinceEpoch.toString();

                    Reference referenceRoot=FirebaseStorage.instance.ref();
                    Reference referenceDirImages=referenceRoot.child('images');

                    Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);

                    try {
                      await referenceImageToUpload.putFile(File(file!.path));
                      imageUrl =await referenceImageToUpload.getDownloadURL();
                    }
                    catch(error){

                    }



                  },
                  child: Text("Select Image"),
                ),

                if (isSavingData)
                  Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  RoundButton(
                    title: 'Add Car',
                    onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        // Set isSavingData to true to show a loading indicator
                        setState(() {
                          isSavingData = true;
                        });

                        // Call the function to save cleaning service data
                        await addCar();
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
