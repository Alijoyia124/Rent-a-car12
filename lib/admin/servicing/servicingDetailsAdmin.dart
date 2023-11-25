import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'ServicingOrderList.dart';
import 'addServicingAdmin.dart';
import 'allAddedServicing.dart';
class ServicingAdmin extends StatefulWidget {
  const ServicingAdmin({Key? key}) : super(key: key);

  @override
  State<ServicingAdmin> createState() => _ServicingAdminState();
}

class _ServicingAdminState extends State<ServicingAdmin> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Servicing Orders"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 40,
          mainAxisSpacing: 30,
          children: [

            itemDashboard(
              'Servicing Orders',
              AssetImage('images/icons/servicing.png'), // Replace with your image asset
                  () {
                // Navigate to the Orders page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ServicingOrderList()
                      // Handle UI refresh logic here
                    )
                );
              },
            ),
            itemDashboard(
              ' Add New Service',
              AssetImage('images/icons/servicing.png'), // Replace with your image asset
                  () {
                // Navigate to the Orders page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => addServicingAdmin()
                      // Handle UI refresh logic here
                    )
                );
              },
            ),
            itemDashboard(
              'All Servicing Types',
              AssetImage('images/icons/servicing.png'), // Replace with your image asset
                  () {
                // Navigate to the Orders page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => allAddedServices()
                      // Handle UI refresh logic here
                    )
                );
              },
            ),
          ],
        ),
      ),
    );
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

