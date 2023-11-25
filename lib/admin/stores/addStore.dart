import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../common widgets/round_button.dart';
import '../../common widgets/text_form_field.dart';
import '../../resources/color.dart';

class addStore extends StatefulWidget {
  const addStore({Key? key}) : super(key: key);

  @override
  State<addStore> createState() => _addStoreState();
}

class _addStoreState extends State<addStore> {
  bool isSavingData = false;
  String imageUrl='';


  final _formKey = GlobalKey<FormState>();
  final storenameController=TextEditingController();
  final addressController=TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  final storenameFocusNode=FocusNode();
  final addressFocusNode=FocusNode();



  Future<void> addCleaningAdmin() async {
    // Get the cleaning details from the text controllers

    String storename=storenameController.text;
    String address=addressController.text;

    try {
      if (imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please upload an image")),
        );
      } else {
        // Perform the asynchronous operations after the image is uploaded
        await FirebaseFirestore.instance.collection('addServiceCenterAdmin').add({

          'storename':storenameController.text,
          'address': addressController.text,
          'image': imageUrl, // Add the image URL
        });

        storenameController.clear();
        addressController.clear();
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
              content: Text('Service Center added successfully!'),
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
          content: Text('Error adding Service Center: $e'),
        ),
      );
    } finally {
      // Regardless of success or error, set isSavingData to false here
      setState(() {
        isSavingData = false;
      });
    }
  }
  void dispose() {
    super.dispose();

    storenameController.dispose();
    addressController.dispose();

   storenameFocusNode.dispose();
    addressFocusNode.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Service Center"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InputTextFormField(
                    myController:storenameController,
                    focusNode:  storenameFocusNode,
                    icon: Icon(Icons.person,color: AppColors.primaryMaterialColor,),

                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onFiledSubmittedValue: (value){

                    },
                    keyboardType: TextInputType.name,
                    obscureText: false,
                    hint: "Enter Store Name",
                    onValidator: (value){
                      return value.isEmpty ? "Enter Store Name " : null;
                    }
                ),
                SizedBox(
                  height: 20,
                ),

                InputTextFormField(
                    myController:addressController,
                    focusNode: addressFocusNode,
                    icon: Icon(Icons.home,color: AppColors.primaryMaterialColor,),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onFiledSubmittedValue: (value){

                    },

                    keyboardType: TextInputType.streetAddress,
                    obscureText: false,
                    hint: "Address",
                    onValidator: (value){
                      return value.isEmpty ? "Enter Address" : null;

                    }
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select Service Center Image"),
                        ElevatedButton(
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file= await imagePicker.pickImage(source: ImageSource.gallery);
                            print('${file?.path}');

                            if(file==null)return;

                            String uniqueFileName=DateTime.now().millisecondsSinceEpoch.toString();

                            Reference referenceRoot=FirebaseStorage.instance.ref();
                            Reference referenceDirImages=referenceRoot.child('images/stores');

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
                  SizedBox(height: 40),
                RoundButton(
                  title: 'Add  Service Center',
                  onPress: () async {
                    if (_formKey.currentState!.validate()) {
                      // Set isSavingData to true to show a loading indicator
                      setState(() {
                        isSavingData = true;
                      });

                      // Call the function to save cleaning service data
                      await addCleaningAdmin();
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

