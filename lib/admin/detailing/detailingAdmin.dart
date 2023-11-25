import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'addDetailingAdmin.dart';
import 'allAddedDetailing.dart';
import 'detailingOrderList.dart';
class detailingAdmin extends StatefulWidget {
  const detailingAdmin({Key? key}) : super(key: key);

  @override
  State<detailingAdmin> createState() => _detailingAdminState();
}

class _detailingAdminState extends State<detailingAdmin> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detailing Orders"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [

            itemDashboard(
              'Detailing Orders',

              AssetImage('images/icons/servicing.png'), // Replace with your image asset
                  () {
                // Navigate to the Orders page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => detailingOrderList()
                      // Handle UI refresh logic here
                    )
                );
              },
            ),
            itemDashboard(
              'Add Detailing Service',
              AssetImage('images/icons/servicing.png'), // Replace with your image asset
                  () {
    // Navigate to the Orders page
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => addDetailingAdmin()
    // Handle UI refresh logic here
    )
    );
    }
    ),
                    itemDashboard(
                      'All Detailing Services',
                      AssetImage('images/icons/servicing.png'),
                      // Replace with your image asset
                          () {
                        // Navigate to the Orders page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => allAddedDetailing()
                              // Handle UI refresh logic here
                            )
                        );
                      },
    )]
      )

      ) );
    }



  itemDashboard(String title, ImageProvider<Object> imageProvider, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image(
                image: imageProvider,
                width: 50,
                height: 60,
              ),
            ),
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.caption!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

