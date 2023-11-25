import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker/resources/color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common widgets/CustomCircularProgressIndicator.dart';
import '../../../common widgets/reusable_row.dart';

class userProfile extends StatefulWidget {
  final String userId;
   // Updated callback function
  final Function(String) onNameUpdate; // Add this line

  const userProfile({
    Key? key,
    required this.userId,
    required this.onNameUpdate, // Add this line
  }) : super(key: key);

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  final storage = FirebaseStorage.instance;
  String? userProfileImageURL;
  String updatedName = ''; // Store the updated name here
  String updatedAge = '';
  String updatedAddress = '';
  File? selectedImage;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Get the reference to the user's profile image
    final Reference storageRef = storage.ref().child('user_profiles/${widget.userId}/profile_image.jpg');

    // Get the download URL for the user's profile image
    storageRef.getDownloadURL().then((url) {
      setState(() {
        userProfileImageURL = url;
      });
    }).catchError((error) {
      print('Error fetching user profile image: $error');
    });

    // Fetch the user data
    fetchUserData().then((userSnapshot) {
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;

        // Set the text controllers with the current data
        nameController.text = userData['username'] ?? '';
        ageController.text = userData['age']?.toString() ?? '';
        addressController.text = userData['address'] ?? '';

        setState(() {
          // Set updatedName, updatedAge, and updatedAddress here as well if needed
          updatedName = userData['username'] ?? '';
          updatedAge = userData['age']?.toString() ?? '';
          updatedAddress = userData['address'] ?? '';
        });
      }
    });
  }


  Future<DocumentSnapshot> fetchUserData() async {
    // Replace 'users' with the name of your Firestore collection
    DocumentSnapshot userSnapshot =
    await FirebaseFirestore.instance.collection('users')
        .doc(widget.userId)
        .get();
    return userSnapshot;
  }

  Future<void> _showChangeNameDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Username'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'New Username'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                // Get the new username from the text field
                updatedName = nameController.text;
                // Update the displayed name immediately
                setState(() {});
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

// Show Change Age
  Future<void> _showChangeAgeDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change your Age'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'New Age'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                // Get the new age from the text field
                updatedAge = ageController.text;
                // Update the displayed age immediately
                setState(() {});
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Show Change Address

  Future<void> _showChangeAddressDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change your Address'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'New Address'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                // Get the new age from the text field
                updatedAddress = addressController.text;
                // Update the displayed age immediately
                setState(() {});
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void updateUserData() async {
    try {
      String newName = nameController.text;
      String newAge = ageController.text;

      // Update the user's name and age in Firestore
      await FirebaseFirestore.instance.collection('users')
          .doc(widget.userId)
          .update({
        'username': newName,
        'age': newAge,
      });

      // Update the text controllers with the new values
      nameController.text = newName;
      ageController.text = newAge;

      // Show a success message or navigate back to the user profile page
      Navigator.pop(context); // Navigate back to the user profile page
    } catch (e) {
      // Handle errors if any
      print('Error updating user data: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to update user data. Please try again later.'),
      ));
    }
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });

      // Get a reference to the location you want to upload the image in Firebase Storage
      final Reference storageRef = storage.ref().child(
          'user_profiles/${widget.userId}/profile_image.jpg');

      // Upload the selected image to Firebase Storage
      await storageRef.putFile(selectedImage!);

      // You can then store the image URL in Firestore, or use it directly in your UI
    }
  }




    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                // Call the updateUserData function when the user saves changes
                updateUserData();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: FutureBuilder<DocumentSnapshot>(
                future: fetchUserData(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CustomCircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text("User data not found");
                  } else {
                    final userData = snapshot.data!.data() as Map<
                        String,
                        dynamic>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 70),
                        GestureDetector(
                          onTap: _selectImage,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 60,
                            child: selectedImage != null
                                ? Image.file(
                                selectedImage!) // Show selected image
                                : userProfileImageURL != null
                                ? Image.network(
                                userProfileImageURL!) // Load profile image
                                : Image.network(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuPXQcWYnlrsAlgi4gzsibLqyWIuhKo2MzThuvCCsG&s", // Placeholder
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),
                        GestureDetector(
                          onTap: () {
                            // Show the change username dialog
                            _showChangeNameDialog(context);
                          },
                          child: reusableRow(
                            title: 'Username',
                            value: updatedName.isNotEmpty
                                ? updatedName
                                : userData['username'],
                            iconData: Icons.person,
                            iconColor: AppColors.primaryMaterialColor,
                          ),
                        ),
                        const Divider(),
                        reusableRow(title: 'Email',
                          value: userData['email'],
                          iconData: Icons.mail,
                        iconColor: AppColors.primaryMaterialColor,),
                        const Divider(),
                        GestureDetector(
                          onTap: () {
                            // Show the change username dialog
                            _showChangeAgeDialog(context);
                          },
                          child: reusableRow(
                            title: 'Age',
                            value: updatedAge.isNotEmpty
                                ? updatedAge
                                : userData['age']?.toString() ?? "",
                            iconData: Icons.numbers_sharp,
                            iconColor: AppColors.primaryMaterialColor,
                          ),
                        ),
                        const Divider(),
                        GestureDetector(
                          onTap: () {
                            // Show the change username dialog
                            _showChangeAddressDialog(context);
                          },
                          child: reusableRow(
                            title: 'Address',
                            value: updatedAddress.isNotEmpty
                                ? updatedAddress
                                : userData['address'],
                            iconData: Icons.home,

                            iconColor: AppColors.primaryMaterialColor,
                          ),
                        ),

                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      );
    }
  }



