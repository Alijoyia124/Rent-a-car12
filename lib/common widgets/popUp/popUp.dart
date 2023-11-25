import 'package:covid_tracker/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../admin/details.dart';
import '../../features/Authentication/screens/login/login.dart';

class UserProfilePopupMenu extends StatelessWidget {

  final auth = FirebaseAuth.instance;


   UserProfilePopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) =>
      [
        PopupMenuItem<int>(
          value: 2,
          child: ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Sign out"),
            onTap: () {
              auth.signOut().then((value) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => loginScreen(),
                    ));
              }).onError((error, stackTrace) {
                utils().toastMessage(error.toString());
              });
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
      ],
      child: Icon(Icons.account_circle), // You can change this icon
      onSelected: (value) {
        if (value == 1) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileDetails()));
        } else if (value == 2) {
          ListTile(
              leading: FaIcon(FontAwesomeIcons.signOutAlt, color: Colors.black),
              title: Text("Sign out"),
              onTap: () {}
            // Then, navigate to the login or sign-in page
            // This ensures that the previous screens are removed from the navigation stack
          );
        }
      },
    );
  }}