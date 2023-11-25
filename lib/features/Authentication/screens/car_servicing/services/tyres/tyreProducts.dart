

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../resources/color.dart';
import '../../../../Controllers/search_Controller.dart';
import 'TyresDetailPage/allTyresDetails.dart';


class TyreProducts extends StatefulWidget {
  const TyreProducts({Key? key}) : super(key: key);

  @override
  State<TyreProducts> createState() => _TyreProductsState();
}

class _TyreProductsState extends State<TyreProducts> {
  List<DocumentSnapshot> favoriteItems = [];
  final _auth = FirebaseAuth.instance;
  User? _user;
  String? _userUID;
  String? _username;
  List<DocumentSnapshot> _filteredData = [];
  late AsyncSnapshot<QuerySnapshot> _snapshot;

  TextEditingController _tyreSizeController = TextEditingController();
  TextEditingController _tyrePriceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final TyreSearchController searchController = TyreSearchController();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user != null) {
      _userUID = _user!.uid;
      getUserUsername(_user!.uid);
    }
    // Load all data from Firestore initially
    FirebaseFirestore.instance
        .collection('addTyreAdmin')
        .get()
        .then((querySnapshot) {
      setState(() {
        _filteredData = querySnapshot.docs;
      });
    });
  }

  void _filterData(String query) {
    setState(() {
      _filteredData = searchController.filterData(_snapshot, query);
    });
  }

  Future<void> getUserUsername(String userId) async {
    try {
      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _username = userData['username'] as String?;
        });
      }
    } catch (e) {
      print('Error retrieving username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All Tyres"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search for a specific tire...",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (query) {
                        _filterData(query);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('addTyreAdmin')
                              .snapshots(),
                          builder:
                              (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            _snapshot =
                                snapshot; // Assign snapshot to the class-level variable
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (_filteredData.isEmpty) {
                              return Center(child: Text('No results found.'));
                            }

                            return ListView.builder(
                                itemCount: _filteredData.length,
                                itemBuilder: (context, index) {
                                  final tyreDocument = _filteredData[index];
                                  final carData = tyreDocument.data() as Map<
                                      String,
                                      dynamic>;

                                  final tyreSize = carData['tyreSize'] ?? 0.0;
                                  final tyrePrice = carData['tyrePrice'] ?? 0.0;
                                  final discount = carData['discount'] ?? '';
                                  final category = carData['category'] ?? '';
                                  final description = carData['description'] ??
                                      '';
                                  bool isFavorite = false; // You can manage the favorite state here.

                                  return Container(
                                      height: 190,
                                      margin: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Card(
                                          color: Colors.white70,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/tyres/tyre2.png",
                                                      height: 70,
                                                      width: 70,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '$category',
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .caption!
                                                            .copyWith(
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    Text('$discount Off'),
                                                    IconButton(
                                                      icon: Icon(
                                                        favoriteItems.contains(
                                                            tyreDocument)
                                                            ? Icons.favorite
                                                            : Icons
                                                            .favorite_border,
                                                        color: AppColors
                                                            .primaryMaterialColor,
                                                      ),
                                                      onPressed: () async {
                                                        setState(() {
                                                          if (favoriteItems
                                                              .contains(
                                                              tyreDocument)) {
                                                            favoriteItems
                                                                .remove(
                                                                tyreDocument);
                                                          } else {
                                                            favoriteItems.add(
                                                                tyreDocument);
                                                          }
                                                        });

                                                        try {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                              'favorites')
                                                              .doc(_userUID)
                                                              .set(
                                                            {
                                                              'username': _username,
                                                              'favorites': favoriteItems
                                                                  .map((item) =>
                                                              {
                                                                'tyreName': item['tyreName'],
                                                                'tyreSize': item['tyreSize'],
                                                              })
                                                                  .toList(),
                                                            },
                                                            SetOptions(
                                                                merge: true),
                                                          );
                                                        } catch (error) {
                                                          print(
                                                              'Error updating favorites with username: $error');
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Price : $tyrePrice',
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .caption!
                                                            .copyWith(
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                    Text('Size : $tyreSize'),
                                                    ]),
                                                    SizedBox(height: 12),
                                                    Align(
                                                      alignment: Alignment.bottomRight,
                                                      child:           Column(
                                                        children: [
                                                        Container(
                                                        height: 35,
                                                        width: 130,
                                                        decoration: BoxDecoration(
                                                          color: AppColors.primaryMaterialColor,
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(11.0),
                                                            bottomRight: Radius.circular(11.0),
                                                          ),
                                                        ),
                                                        child: TextButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => allTyresDetails(
                                                                  category: category,
                                                                  tyreSize: tyreSize,
                                                                  tyrePrice: tyrePrice,
                                                                  discount: discount,
                                                                  description: description,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons.cartShopping,
                                                                color: Colors.white,
                                                              ),
                                                              SizedBox(width: 8),
                                                              Text(
                                                                'Buy Now',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                   ] ),
                                                    )
                                         ]       ),
                                  )));
                                });
                          })
                  )
                ])
        ));
  }

    @override
  void dispose() {
    _tyreSizeController.dispose();
    _tyrePriceController.dispose();
    _discountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
