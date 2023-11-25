import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker/features/Authentication/screens/login/login.dart';
import 'package:covid_tracker/features/Authentication/screens/userProfile.dart';
import 'package:covid_tracker/resources/color.dart';
import 'package:covid_tracker/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../features/Authentication/screens/car_rental/cardetails/favourites.dart';
import '../../features/Authentication/screens/myBookings.dart';
import 'package:share_plus/share_plus.dart';
import 'contactUs.dart';

class sideBar extends StatefulWidget {
  const sideBar({Key? key}) : super(key: key);
  @override
  State<sideBar> createState() => _sideBarState();
}
class _sideBarState extends State<sideBar> {
  List<DocumentSnapshot> favoriteItems = [];  // Add this line to declare and initialize favoriteItems
  List<Map<String, dynamic>> bookings = [];

  final auth = FirebaseAuth.instance;
  User? user;
  String? userUID;
  String? userEmail;
  String? userName;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController(); // Add this line

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    if (user != null) {
      userUID = user!.uid;
      userEmail = user!.email;

      // Fetch additional user data from Firestore
      fetchUserData();
    }
  }

  Future<void> fetchUserData() async {
    try {
      // Access the "users" collection in Firestore
      var userDocument =
      await FirebaseFirestore.instance.collection('users').doc(userUID).get();

      // Check if the document exists
      if (userDocument.exists) {
        // Extract additional user data
        var userData = userDocument.data() as Map<String, dynamic>;

        // Extract user email and name
        userEmail = userData['email'];
        userName = userData['username']; // Set the userName variable

        // Update the state or perform other actions with the data
        setState(() {
          // Update the userEmail and userName
        });
      }
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  void updateUserData() async {
    try {
      String newName = nameController.text;
      String newAge = ageController.text;

      // Update the user's name and age in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userUID).update({
        'username': newName,
        'age': newAge,
      });

      // Update the user's display name in Firebase Authentication
      await FirebaseAuth.instance.currentUser!.updateDisplayName(newName);

      // Update the text controllers with the new values
      nameController.text = newName;
      ageController.text = newAge;

      // Show a success message or navigate back to the user profile page
      Navigator.pop(context); // Navigate back to the user profile page
    } catch (e) {
      // Handle errors if any
      print('Error updating user data: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Failed to update user data. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName ?? "",
              style: Theme.of(context).textTheme.headline5!.copyWith(
              color: Colors.white,
                  fontWeight: FontWeight.bold
            ),),
            accountEmail: null,
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(""),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryMaterialColor,
              image: DecorationImage(image: AssetImage(""), fit: BoxFit.cover),
            ),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.user, color: Colors.black),
            title: Text("Profile",
    style: Theme.of(context).textTheme.headline6!.copyWith(
    fontWeight: FontWeight.bold
    ),),
            trailing: FaIcon(FontAwesomeIcons.angleRight, color: Colors.black),
            onTap: () {
              if (userUID != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => userProfile(
                      userId: userUID ?? "",
                      onNameUpdate: (newName) {
                        // Update the displayed name in sideBar
                        setState(() {
                          userName = newName;
                        });
                      },
                    ),
                  ),
                );
              }
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.switch_account),
          //   title: Text(
          //     'Switch to Rental Module',
          //     style: Theme.of(context).textTheme.headline6!.copyWith(
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => carRental(), // Replace with the actual page for the rental module
          //       ),
          //     );
          //   },
          // ),
          Divider(),

          ListTile(
            leading: FaIcon(FontAwesomeIcons.list,color: Colors.black),
            title: Text("My Bookings",
    style: Theme.of(context).textTheme.headline6!.copyWith(
    fontWeight: FontWeight.bold
    ),),
            trailing: FaIcon(FontAwesomeIcons.angleRight,color: Colors.black,),
            onTap: (){
              Get.to(()=> Mybookings(),transition:Transition.fade,duration: Duration(seconds: 1));
            },

          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.book,color: Colors.black),
            title: Text("Book Now",    style: Theme.of(context).textTheme.headline6!.copyWith(
    fontWeight: FontWeight.bold
    ),),
            trailing: FaIcon(FontAwesomeIcons.angleRight,color: Colors.black,),
            onTap: (){
            },
          ),
          Divider(),
          ListTile(
            leading:  FaIcon(FontAwesomeIcons.heart,color: Colors.black),
            title: Text("Favorites",
    style: Theme.of(context).textTheme.headline6!.copyWith(
    fontWeight: FontWeight.bold
    ),),
              trailing: FaIcon(FontAwesomeIcons.angleRight,color: Colors.black,),
              onTap: (){
                Get.to(() => LikedCarsPage(), transition: Transition.fade, duration: Duration(seconds: 1));

              }
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.phone,color: Colors.black),
            title: Text("Customer Support",
    style: Theme.of(context).textTheme.headline6!.copyWith(
    fontWeight: FontWeight.bold
    ),),
              trailing: FaIcon(FontAwesomeIcons.angleRight,color: Colors.black,),
              onTap: (){
                Get.to(()=> ContactUs(),transition:Transition.fade,duration: Duration(seconds: 1));

              }
          ),
          Divider(),
          ListTile(
          leading: FaIcon(FontAwesomeIcons.share, color: Colors.black),
    title: Text(
    "Share App",
    style: Theme.of(context).textTheme.headline6!.copyWith(
    fontWeight: FontWeight.bold,
    ),
    ),
    onTap: () {
    // Share the app when the ListTile is tapped
    Share.share("Check out this amazing car rental app!");
    },
            trailing: FaIcon(FontAwesomeIcons.angleRight,color: Colors.black,),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0), // Adjust vertical spacing as needed
            color: Colors.black, // Divider color
            height: 1.0, // Divider thickness
          ),
    ListTile(
    leading: FaIcon(
    FontAwesomeIcons.signOutAlt,
    color: Colors.black,
    ),
    title: Text(
    "Sign out",
    style: Theme.of(context).textTheme.caption!.copyWith(
    fontSize: 16, fontWeight: FontWeight.bold),
    ),
    onTap: () {
    // Show a confirmation dialog before signing out
    showDialog(
    context: context,
    builder: (BuildContext context) {
    return AlertDialog(
    title: Text("Confirm Sign Out",style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),),
    content: Text("Are you sure you want to sign out?"),
    actions: [
    TextButton(
    onPressed: () {
    Navigator.of(context).pop(); // Close the dialog
    },
    child: Text("Cancel"),
    ),
    TextButton(
    onPressed: () {
    auth.signOut().then((value) {
    Navigator.of(context).pushReplacement(
    MaterialPageRoute(
    builder: (context) => loginScreen(),
    ),
    );
    }).onError((error, stackTrace) {
    utils().toastMessage(error.toString());
    });
    Navigator.of(context).popUntil((route) => route.isFirst);
    },
    child: Text("Sign Out"),
    ),
    ],
    );
    },
    );
    },
    )
  ]  )
    );
  }}
