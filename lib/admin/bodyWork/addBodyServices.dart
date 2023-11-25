import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../common widgets/round_button.dart';

class bodyWorkAdmin extends StatefulWidget {
  const bodyWorkAdmin({Key? key}) : super(key: key);

  @override
  State<bodyWorkAdmin> createState() => _bodyWorkAdminState();
}

class _bodyWorkAdminState extends State<bodyWorkAdmin> {
  bool isSavingData = false;
  String? selectedCategory;
  String imageUrl='';
  List<String> cleaningCategories = [
    'Penal Painting',
    'Underbody Painting',
    'Rust Work',
    'Dent Removal',
    'Car Restoration',
  ];

  final _formKey = GlobalKey<FormState>();
  TextEditingController _bodyPriceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _sedanservicingPriceController = TextEditingController();
  TextEditingController _hatchbackservicingPriceController = TextEditingController();
  TextEditingController _crossoverservicingPriceController = TextEditingController();
  TextEditingController _mainCategoryController = TextEditingController();

  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //
  //   if (pickedFile == null) {
  //     // No image was picked.
  //     return null;
  //   }
  //
  //   final storage = FirebaseStorage.instance;
  //   final Reference storageReference =
  //   storage.ref().child('cleaning_images/${DateTime.now().millisecondsSinceEpoch}');
  //
  //   final UploadTask uploadTask = storageReference.putFile(File(pickedFile.path));
  //   final TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
  //
  //   if (storageTaskSnapshot.state == TaskState.success) {
  //     final imageUrl = await storageReference.getDownloadURL();
  //     return imageUrl;
  //   }
  //
  //   return null;
  // }

  Future<void> addbodyAdmin() async {
    // Get the cleaning details from the text controllers

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
        await FirebaseFirestore.instance.collection('addBodyWorkAdmin').add({
          'sedanservicingPrice': sedanPrice,
          'hatchbackservicingPrice': hatchbackPrice,
          'crossoverservicingPrice': crossoverPrice,
          'discount': discount,
          'category': selectedCategory,
          'description': description,
          'image': imageUrl, // Add the image URL
          'mainCategory':mainCategory
        });

        // Reset the form
        _sedanservicingPriceController.clear();
        _hatchbackservicingPriceController.clear();
        _crossoverservicingPriceController.clear();
        _mainCategoryController.clear();
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
              content: Text('BodyWork Service added successfully!'),
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
          content: Text('Error adding BodyWork Service: $e'),
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
        title: Text("New BodyWork Service"),
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
                      'Select BodyWork Service:',
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
                ), TextFormField(
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
                  controller: _discountController,
                  decoration: InputDecoration(labelText: 'Discount'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter BodyWork Discount';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description of BodyWork Service'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter BodyWork Service';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file= await imagePicker.pickImage(source: ImageSource.gallery);
                    print('${file?.path}');

                    if(file==null)return;

                    String uniqueFileName=DateTime.now().millisecondsSinceEpoch.toString();

                    Reference referenceRoot=FirebaseStorage.instance.ref();
                    Reference referenceDirImages=referenceRoot.child('images/bodyWork');

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
                    title: 'Add BodyWork Service',
                    onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        // Set isSavingData to true to show a loading indicator
                        setState(() {
                          isSavingData = true;
                        });

                        // Call the function to save cleaning service data
                        await addbodyAdmin();
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
