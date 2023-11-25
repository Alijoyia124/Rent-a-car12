import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../../../resources/color.dart';
import 'allBodyDetails.dart';

    class bodyWork extends StatefulWidget {
    const bodyWork({Key? key}) : super(key: key);

    @override
    State<bodyWork> createState() => _bodyWorkState();
    }


        class _bodyWorkState extends State<bodyWork> {
        String selectedCategory = 'View All';
        late Stream<QuerySnapshot> _stream;

        @override
        void initState() {
        super.initState();
        // Initialize the stream to listen for updates
        _stream = FirebaseFirestore.instance.collection('addBodyWorkAdmin').snapshots();
        }

        @override
        Widget build(BuildContext context) {
            return Scaffold(
                appBar: AppBar(
                    title: Text("BodyWork Services"),
                ),
                body: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                        children: [
                            buildCategoryScrollView(),
                            Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: _stream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                        if (snapshot.hasError) {
                                            return Center(child: Text(
                                                'Error: ${snapshot.error}'));
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                            return Center(
                                                child: CircularProgressIndicator());
                                        }

                                        final filteredData = getFilteredData(
                                            snapshot);

                                        if (filteredData.isEmpty) {
                                            return Center(child: Text(
                                                'No results found.'));
                                        }

                                        return ListView.builder(
                                            itemCount: filteredData.length,
                                            itemBuilder: (context, index) {
                                                final cleaningDocument = filteredData[index];
                                                final carData = cleaningDocument
                                                    .data() as Map<
                                                    String,
                                                    dynamic>;

                                                final description = carData['description'] ??
                                                    '';
                                                final discount = carData['discount'] ??
                                                    '';
                                                final category = carData['category'] ??
                                                    '';
                                                final mainCategory = carData['mainCategory'] ??
                                                    '';
                                                final serviceType = carData['serviceType'] ??
                                                    '';
                                                final servicingOption = carData['servicingOption'] ??
                                                    '';
                                                final hatchbackPrice = carData['hatchbackservicingPrice'] ??
                                                    0.0;
                                                final sedanPrice = carData['sedanservicingPrice'] ??
                                                    0.0;
                                                final crossoverPrice = carData['crossoverservicingPrice'] ??
                                                    0.0;
                                                final image = carData['image'];


                                                return Stack(
                                                    children: [
                                                        // Container for the tire information
                                                        Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                7, 8, 7, 8),
                                                            height: 110,
                                                            width: double
                                                                .infinity,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white70,
                                                                boxShadow: [
                                                                    BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                            0.2),
                                                                        spreadRadius: 2,
                                                                        blurRadius: 2,
                                                                        offset: Offset(
                                                                            0,
                                                                            3),
                                                                    ),
                                                                ],
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    10),
                                                                border: Border
                                                                    .all(
                                                                    color: Colors
                                                                        .grey),
                                                            ),
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                    Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical: 12,
                                                                            horizontal: 17),
                                                                        child: Row(
                                                                            children: [
                                                                                Container(
                                                                                    height: 70,
                                                                                    // Adjust the height as needed
                                                                                    child: CircleAvatar(
                                                                                        radius: 30,
                                                                                        // Adjust the radius as needed
                                                                                        backgroundImage: NetworkImage(
                                                                                            image),
                                                                                    ),
                                                                                ),
                                                                                SizedBox(
                                                                                    width: 7),
                                                                                Column(
                                                                                    children: [
                                                                                        Row(
                                                                                            children: [
                                                                                                Text(
                                                                                                    '$category',
                                                                                                    style: Theme
                                                                                                        .of(
                                                                                                        context)
                                                                                                        .textTheme
                                                                                                        .caption!
                                                                                                        .copyWith(
                                                                                                        fontWeight: FontWeight
                                                                                                            .bold,
                                                                                                        fontSize: 16,
                                                                                                    ),
                                                                                                ),
                                                                                            ],
                                                                                        ),
                                                                                        Row(
                                                                                            children: [
                                                                                                Column(
                                                                                                    children: [
                                                                                                        Text(
                                                                                                            'Price : ',
                                                                                                            style: Theme
                                                                                                                .of(
                                                                                                                context)
                                                                                                                .textTheme
                                                                                                                .caption!
                                                                                                                .copyWith(
                                                                                                                fontWeight: FontWeight
                                                                                                                    .bold,
                                                                                                                fontSize: 15,
                                                                                                            ),
                                                                                                        ),
                                                                                                    ]),
                                                                                                Column(
                                                                                                    children: [
                                                                                                        Text(
                                                                                                            '$sedanPrice',
                                                                                                        ),
                                                                                                    ])
                                                                                            ],
                                                                                        ),
                                                                                    ],
                                                                                ),
                                                                            ],
                                                                        ),
                                                                    ),
                                                                ]),
                                                        ),
                                                        // Heart icon for marking as favorite (top right corner)
                                                        Positioned(
                                                            top: 17,
                                                            right: 15,
                                                            child: Row(
                                                                children: [
                                                                    Text('$discount Off'),
                                                                ],
                                                            ),
                                                        ),
                                                        Positioned(
                                                            bottom: 9,
                                                            right: 8,
                                                            child: Container(
                                                                height: 35,
                                                                width: 130,
                                                                decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .primaryMaterialColor,
                                                                    borderRadius: BorderRadius
                                                                        .only(
                                                                        topLeft: Radius
                                                                            .circular(
                                                                            11.0),
                                                                        bottomRight: Radius
                                                                            .circular(
                                                                            11.0), // You can adjust the radius as needed
                                                                    ),
                                                                ),
                                                                child: InkWell(
                                                                    onTap: () {
                                                                        Get
                                                                            .to(() =>
                                                                            allBodyDetails(
                                                                                category: category,
                                                                                discount: discount,
                                                                                image: image,
                                                                                description: description, serviceType: serviceType,
                                                                                servicingOption: servicingOption,
                                                                                hatchbackPrice: hatchbackPrice,
                                                                                sedanPrice: sedanPrice,
                                                                                crossoverPrice:crossoverPrice,
                                                                                mainCategory:mainCategory
                                                                            ),
                                                                            transition: Transition
                                                                                .fade,
                                                                            duration: const Duration(
                                                                                seconds: 1));
                                                                    },
                                                                    child: Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal: 10),
                                                                        child: Row(
                                                                            children: [
                                                                                FaIcon(
                                                                                    (FontAwesomeIcons
                                                                                        .cartShopping),
                                                                                    color: Colors
                                                                                        .white, // You can set the desired color
                                                                                ),
                                                                                SizedBox(
                                                                                    width: 8),
                                                                                Text(
                                                                                    'Buy Now',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .white
                                                                                    ),),
                                                                            ]),
                                                                    ),
                                                                )
                                                            ),
                                                        ),
                                                    ]
                                                );
                                            },
                                        );
                                    }))
                        ]),
                )
            );
        }


List<QueryDocumentSnapshot> getFilteredData(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<QueryDocumentSnapshot> data = snapshot.data!.docs;

    if (selectedCategory == 'View All') {
        return data;
    } else {
        return data.where((doc) => doc['category'] == selectedCategory).toList();
    }
}

Widget buildCategoryScrollView() {
    List<String> categories = [
        'View All',
        'Penal Painting',
        'Underbody Painting',
        'Dent Removal',
        'Car Restoration',
        // Add more categories here
    ];

    return Container(
        height: 50,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
                String category = categories[index];
                return GestureDetector(
                    onTap: () {
                        onCategorySelected(category);
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: selectedCategory == category
                                ? AppColors.primaryMaterialColor
                                : Colors.black,
                        ),
                        child: Text(
                            category,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                            ),
                        ),
                    ),
                );
            },
        ),
    );
}

        void onCategorySelected(String category) {
            setState(() {
                selectedCategory = category;
            });
        }
        }