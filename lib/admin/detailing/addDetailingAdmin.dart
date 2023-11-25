import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../common widgets/round_button.dart';

class addDetailingAdmin extends StatefulWidget {
  const addDetailingAdmin({Key? key}) : super(key: key);

  @override
  State<addDetailingAdmin> createState() => _addDetailingAdminState();
}

class _addDetailingAdminState extends State<addDetailingAdmin> {
  bool isSavingData = false;
  String? selectedCategory;
  String imageUrl='';
  List<String> cleaningCategories = [
    'Interior Detailing',
    'Complete Exterior Detailing',
    'Full Car Detailing',
    'Full Car Restoration',
  ];

  final _formKey = GlobalKey<FormState>();
  TextEditingController _cleaningPriceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _sedanservicingPriceController = TextEditingController();
  TextEditingController _hatchbackservicingPriceController = TextEditingController();
  TextEditingController _crossoverservicingPriceController = TextEditingController();
  TextEditingController _mainCategoryController = TextEditingController();


  Future<void> addDetailAdmin() async {
    double sedanPrice = double.parse(_sedanservicingPriceController.text);
    double hatchbackPrice = double.parse(_hatchbackservicingPriceController.text);
    double crossoverPrice = double.parse(_crossoverservicingPriceController.text);
    String discount = _discountController.text;
    String description = _descriptionController.text;
    String mainCategory = _mainCategoryController.text;


    try {
      if (imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please upload an image")),
        );
      } else {
        // Perform the asynchronous operations after the image is uploaded
        await FirebaseFirestore.instance.collection('addDetailingAdmin').add({
          'sedanservicingPrice': sedanPrice,
          'hatchbackservicingPrice': hatchbackPrice,
          'crossoverservicingPrice': crossoverPrice,
          'servicingOption': selectedCategory,
          'description': description,
          'mainCategory':mainCategory,
          'image': imageUrl, // Add the image URL
        });

        // Reset the form
        _sedanservicingPriceController.clear();
        _hatchbackservicingPriceController.clear();
        _crossoverservicingPriceController.clear();
        _mainCategoryController.clear();
        _cleaningPriceController.clear();
        _discountController.clear();
        _descriptionController.clear();
        imageUrl = ''; // Reset imageUrl

        // Show a success dialog
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
              content: Text('Cleaning Service added successfully!'),
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
          content: Text('Error adding Cleaning Service: $e'),
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
        title: Text("Add New Detailing Service"),
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
                      'Select Detailing Service:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                      items: cleaningCategories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                TextFormField(
                  controller: _discountController,
                  decoration: InputDecoration(labelText: 'Discount'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Cleaning Discount';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _sedanservicingPriceController,
                  decoration: InputDecoration(labelText: 'Service Price(Sedan)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Service Price';
                    }
                    // You can add more validation for numeric input if needed
                    return null;
                  },
                ),
                TextFormField(
                  controller: _mainCategoryController,
                  decoration: InputDecoration(labelText: 'Main Category'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Main Category';
                    }
                    // You can add more validation for numeric input if needed
                    return null;
                  },
                ),
                TextFormField(
                  controller: _hatchbackservicingPriceController,
                  decoration: InputDecoration(labelText: 'Service Price(Hatchback)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Service Price';
                    }
                    // You can add more validation for numeric input if needed
                    return null;
                  },
                ),
                TextFormField(
                  controller: _crossoverservicingPriceController,
                  decoration: InputDecoration(labelText: 'Service Price(Crossover)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Service Price';
                    }
                    // You can add more validation for numeric input if needed
                    return null;
                  },
                ),

                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description of Detailing Service'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Detailing Service';
                    }
                    return null;
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Image"),
                  ElevatedButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file= await imagePicker.pickImage(source: ImageSource.gallery);
                      print('${file?.path}');

                      if(file==null)return;

                      String uniqueFileName=DateTime.now().millisecondsSinceEpoch.toString();

                      Reference referenceRoot=FirebaseStorage.instance.ref();
                      Reference referenceDirImages=referenceRoot.child('images/detailing');

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
]),
                ),
                if (isSavingData)
                  Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  RoundButton(
                    title: 'Add Detailing Service',
                    onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        // Set isSavingData to true to show a loading indicator
                        setState(() {
                          isSavingData = true;
                        });
                        // Call the function to save cleaning service data
                        await addDetailAdmin();
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
