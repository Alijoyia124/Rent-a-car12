import 'package:covid_tracker/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.envelope,
              size: 60,
              color: AppColors.primaryMaterialColor,
            ),
            SizedBox(height: 20),
            Text(
              'How can we Help you?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Color of the shadow
                    spreadRadius: 3, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(10), // Adjust the radius as needed
                ),
                color: Colors.white, // Set the background color
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white, // Set the background color of the CircleAvatar
                  radius: 30,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30), // Make it a circle
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grayColor.withOpacity(0.9),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      FontAwesomeIcons.solidEnvelope,
                      color: AppColors.primaryMaterialColor,
                        size: 25 // Set the size of the icon
                    ),
                  ),
                ),
                // Add other ListTile properties as needed
              title: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'contact@example.com',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7), // Color of the shadow
              spreadRadius: 3, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(0, 2), // Changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(10), // Adjust the radius as needed
          ),
          color: Colors.white, // Set the background color
        ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white, // Set the background color of the CircleAvatar
                  radius: 30,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30), // Make it a circle
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grayColor.withOpacity(0.7),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      FontAwesomeIcons.phone,
                      color: AppColors.primaryMaterialColor,
                      size: 25 // Set the size of the icon
                    ),
                  ),
                ),
              title: Text(
                  'Phone',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '0304-6565656',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7), // Color of the shadow
                    spreadRadius: 3, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(10), // Adjust the radius as needed
                ),
                color: Colors.white, // Set the background color
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white, // Set the background color of the CircleAvatar
                  radius: 30,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30), // Make it a circle
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grayColor.withOpacity(0.7),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                        FontAwesomeIcons.twitter,
                        color: AppColors.primaryMaterialColor,
                        size: 25 // Set the size of the icon
                    ),
                  ),
                ),
                title: Text(
                  'Twitter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            ),
            SizedBox(height: 15,),
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7), // Color of the shadow
                    spreadRadius: 3, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(10), // Adjust the radius as needed
                ),
                color: Colors.white, // Set the background color
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white, // Set the background color of the CircleAvatar
                  radius: 30,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30), // Make it a circle
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grayColor.withOpacity(0.7),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                        FontAwesomeIcons.facebook,
                        color: AppColors.primaryMaterialColor,
                        size: 25 // Set the size of the icon
                    ),
                  ),
                ),
                title: Text(
                    'Facebook',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
