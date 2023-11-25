import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../common widgets/round_button.dart';
class addServicingAdmin extends StatefulWidget {
  const addServicingAdmin({Key? key}) : super(key: key);

  @override
  State<addServicingAdmin> createState() => _addServicingAdminState();
}

class _addServicingAdminState extends State<addServicingAdmin> {
  final formkey = GlobalKey<FormState>();
  String selectedServiceCategory = 'Bodywork';


  bool isSavingData = false;
  String selectedImageName = '';
  String selectedMainCategory = 'Major Servicing';
  String selectedSubCategory = 'Brake fluid replacement';
  String image = '';
  List<String> serviceCategories = [
    'Bodywork',
    'Cleaning',
    'Detailing',
    'Servicing',
    'Repairs',
  ];
  List<String> MainCategory = [
    'Interim Servicing',
    'Major Servicing',
    'Full Car Servicing'
  ];
  Map<String, List<String>> SubCategory = {
    'Interim Servicing': [
      'Oil change',
      'Oil filter replacement',
      'Inspect drive belt',
    ],
    'Major Servicing': [
      'Brake fluid replacement',
      'Odour and allergy filter replacement',
      'Spark plugs replacement',
      'Automatic transmission oil level inspection'
    ],
    'Full Car Servicing': [
      'Suspension System Inspection',
      'Fuel filter replacement (for diesel cars)',
      'Air cleaner replacement',
      'Alternator hose and vacuum hose inspection',
      'Parking brake shoes inspection',
      'Wheels Alignment'
    ],
  };
  final _formKey = GlobalKey<FormState>();
  TextEditingController _sedanservicingPriceController = TextEditingController();
  TextEditingController _hatchbackservicingPriceController = TextEditingController();
  TextEditingController _crossoverservicingPriceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Future<void> addServicing() async {
    // Get the selected categories from the state
    String selectedType = selectedMainCategory;
    String selectedOption = selectedSubCategory;

    // Get the servicing details from the text controllers
    double sedanPrice = double.parse(_sedanservicingPriceController.text);
    double hatchbackPrice = double.parse(_hatchbackservicingPriceController.text);
    double crossoverPrice = double.parse(_crossoverservicingPriceController.text);
    String discount = _discountController.text;
    String description = _descriptionController.text;

    try {
      if (image.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please upload an image")),
        );
      } else {
        // Perform the asynchronous operations after the image is uploaded
        await FirebaseFirestore.instance.collection('addServicingAdmin').add({
          'sedanservicingPrice': sedanPrice,
          'hatchbackservicingPrice': hatchbackPrice,
          'crossoverservicingPrice': crossoverPrice,
          'discount': discount,
          'description': description,
          'service':selectedServiceCategory,
          'serviceType': selectedMainCategory, // Add the selected car type
          'servicingOption': selectedSubCategory, // Add the selected servicing option
          'image': image, // Add the image URL
        });

        // Reset the form and selected categories
        _sedanservicingPriceController.clear();
        _hatchbackservicingPriceController.clear();
        _crossoverservicingPriceController.clear();
        _discountController.clear();
        _descriptionController.clear();
        selectedMainCategory = ''; // Reset selected car type
        selectedOption = ''; // Reset selected servicing option
        image = ''; // Reset imageUrl

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
              content: Text('Service added successfully!'),
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
          content: Text('Error adding Service: $e'),
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
        title: Text("Servicing"),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 17, 20),
              width: double.infinity,
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    DropdownButtonFormField<String>(
                      value: selectedServiceCategory,
                      items: serviceCategories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedServiceCategory = value!;

                        });
                      },
                      decoration: const InputDecoration(labelText: 'Service Category'),
                    ),

                    DropdownButtonFormField<String>(
                      value: selectedMainCategory,
                      items: MainCategory.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMainCategory = value!;
                          selectedSubCategory =
                          SubCategory[selectedMainCategory]![0];
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Car Type'),
                    ),

                    DropdownButtonFormField<String>(
                      value: selectedSubCategory,
                      items: SubCategory[selectedMainCategory]!.map((model) {
                        return DropdownMenuItem<String>(
                          value: model,
                          child: Text(model),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSubCategory = value!;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Car model'),
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
                          return 'Please enter Cleaning Discount';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                          labelText: 'Description of Service'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Service';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50),


                    ElevatedButton(
                      onPressed: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                        print('${file?.path}');

                        if (file == null) return;

                        // Set the selected image name
                        selectedImageName = file.name;

                        String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

                        Reference referenceRoot = FirebaseStorage.instance.ref();
                        Reference referenceDirImages = referenceRoot.child('images/servicing');

                        Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

                        try {
                          await referenceImageToUpload.putFile(File(file.path));
                          image = await referenceImageToUpload.getDownloadURL();
                        } catch (error) {
                          // Handle the error if needed
                        }
                      },
                      child: Column(
                        children: [
                          Text("Select Image"),
                          if (selectedImageName.isNotEmpty) Text(selectedImageName) // Display the selected image name
                        ],
                      ),
                    ),


                    if (image.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            // Change the border color as needed
                            width: 2.0, // Adjust the border width as needed
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Shadow color
                              spreadRadius: 3, // Spread radius
                              blurRadius: 7, // Blur radius
                              offset: Offset(0, 3), // Shadow offset
                            ),
                          ],
                        ),
                        child: Image.network(image, width: 100,
                            height: 100), // Adjust width and height as needed
                      ),

                    if (isSavingData)
                      const CircularProgressIndicator(),
                    if (!isSavingData)
                      RoundButton(
                        title: 'Buy Now',
                        onPress: () async {
                          if (formkey.currentState!.validate()) {
                            // Set isSavingData to true to show a loading indicator
                            setState(() {
                              isSavingData = true;
                            });

                            // Call the function to save servicing data
                            await addServicing().then((_) {
                              // Data has been successfully saved
                              print('Servicing data saved to Firestore.');

                              // You can also show a success message to the user or navigate to another screen.
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Success'),
                                    content: const Text(
                                        'Service added successfully!'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }).catchError((error) {
                              // Handle any errors that may occur during the data-saving process
                              print('Error adding Service: $error');

                              // Show an error message in a dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: Text(
                                        'An error occurred while adding the service: $error'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: const Text('OK'),
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
                            });
                          }
                        },
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
}