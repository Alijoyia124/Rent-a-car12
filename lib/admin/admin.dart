import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker/admin/cleaning/cleaningDetailsAdmin.dart';
import 'package:covid_tracker/admin/servicing/servicingDetailsAdmin.dart';
import 'package:covid_tracker/admin/tyres/tyresDetailsAdmin.dart';
import 'package:covid_tracker/admin/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common widgets/popUp/popUp.dart';
import '../resources/color.dart';
import 'bodyWork/bodyDetailsAdmin.dart';
import 'detailing/detailingAdmin.dart';
import 'rentalAdmin/rentalCategoriesAdmin.dart';
import 'stores/storesCategories.dart';

class adminPanel extends StatefulWidget {
  const adminPanel({Key? key}) : super(key: key);

  @override
  State<adminPanel> createState() => _adminPanelState();
}

class _adminPanelState extends State<adminPanel> {
  final auth = FirebaseAuth.instance;
  int registeredUserCount = 0;
  bool isServicingExpanded = false;
  bool isRentalExpanded = false;

  @override
  void initState() {
    super.initState();
    // Call the countRegisteredUsers method when the widget initializes
    countRegisteredUsers().then((count) {
      setState(() {
        registeredUserCount = count;
      });
    });
  }

  Future<int> countRegisteredUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      // Return the number of documents in the collection
      return querySnapshot.size;
    } catch (e) {
      // Handle any errors here
      print('Error counting registered users: $e');
      return 0;
    }
  }

  Future<void> _refreshData() async {
    // Call your data update method here
    await countRegisteredUsers().then((count) {
      setState(() {
        registeredUserCount = count;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Panel",
          style: Theme.of(context).textTheme.headline4!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: UserProfilePopupMenu(),
          ), // Add the profile icon with the popup menu here
        ],
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryMaterialColor,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 30),
                    title: Text('Hello Admin!',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.white)),

                  ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(200),
                  ),
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 30,
                  children: [

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isServicingExpanded = !isServicingExpanded;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 5),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.2),
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
                                image:
                                AssetImage('images/icons/service.png'),
                                width: 50,
                                height: 60,
                              ),
                            ),
                            Text('Servicing'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(()=> rentalCategoriesAdmin(),transition:Transition.fade,duration: Duration(seconds: 1));

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 5),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.2),
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
                                image:
                                AssetImage('images/icons/rental.jpg'),
                                width: 50,
                                height: 60,
                              ),
                            ),
                            Text('Rental'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(()=> storesCategories(),transition:Transition.fade,duration: Duration(seconds: 1));

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 5),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.2),
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
                                image:
                                AssetImage('images/icons/rental.jpg'),
                                width: 50,
                                height: 60,
                              ),
                            ),
                            Text('Servicing Stores'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ),
                    ),


                    // Show the other item boards conditionally based on isServicingExpanded
                    if (isServicingExpanded) ...[
                      itemDashboard(
                        'Users',
                        AssetImage(''),
                        registeredUserCount,
                            () {
                          // Navigate to the Users page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => users(),
                            ),
                          );
                        },
                      ),
                      itemDashboard(
                        'Tyres',
                        AssetImage('images/icons/tyre.png'),
                        registeredUserCount,
                            () {
                          // Navigate to the TyresDetailsAdmin page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TyresDetailsAdmin(),
                            ),
                          );
                        },
                      ),
                      itemDashboard(
                        'Detailing',
                        AssetImage('images/icons/repairs.png'),
                        registeredUserCount,
                            () {
                          // Navigate to the Videos page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => detailingAdmin(),
                            ),
                          );
                        },
                      ),
                      itemDashboard(
                        'Cleaning',
                        AssetImage('images/icons/cleaning.png'),
                        registeredUserCount,
                            () {
                          // Navigate to the Videos page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => cleaningDetailsAdmin(),
                            ),
                          );
                        },
                      ),
                      itemDashboard(
                        'Servicing',
                        AssetImage('images/icons/servicing.png'),
                        registeredUserCount,
                            () {
                          // Navigate to the Videos page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServicingAdmin(),
                            ),
                          );
                        },
                      ),
                      itemDashboard(
                        'Body Work',
                        AssetImage('images/icons/body.png'),
                        registeredUserCount,
                            () {
                          // Navigate to the Videos page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => bodyDetailsAdmin(),
                            ),
                          );
                        },
                      ),
                    ],

                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  itemDashboard(
      String title,
      ImageProvider<Object> imageProvider,
      int userCount, // Add this parameter for user count
      void Function()? onTap,
      ) {
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
              // Increase padding for larger image
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image(
                image: imageProvider,
                width: 50,
                height: 60,
              ), // Adjust width and height for a larger image
            ),
            // Display user count below the title
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.caption!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            // Display user count below the title only for the "Users" tile
            if (title == 'Users')
              Text('$userCount',
                  style: Theme.of(context).textTheme.caption),
          ],
        ),
      ),
    );
  }
}
