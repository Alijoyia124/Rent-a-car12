import 'package:covid_tracker/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'allDetailingDetails.dart';

class detailingWork extends StatefulWidget {
  const detailingWork({Key? key}) : super(key: key);

  @override
  State<detailingWork> createState() => _detailingWorkState();
}

class _detailingWorkState extends State<detailingWork> {
  List<DocumentSnapshot> filteredData = [];
  late AsyncSnapshot<QuerySnapshot> _snapshot;
  TextEditingController _discountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Future<void> fetchDetailingData() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('addDetailingAdmin').get();
    setState(() {
      filteredData = querySnapshot.docs;
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch detailing data from Firestore
    fetchDetailingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Detailing Services"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
              children: [
          Expanded(
          child: filteredData.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final detailingDocument = filteredData[index];
        final carData = detailingDocument.data() as Map<String, dynamic>;

        final description = carData['description'] ?? '';
        final sedanPrice = carData['sedanservicingPrice'] ??
            0.0;
        final serviceType = carData['serviceType'] ??
            '';
        final servicingOption = carData['servicingOption'] ??
            '';
        final hatchbackPrice = carData['hatchbackservicingPrice'] ??
            0.0;
        final crossoverPrice = carData['crossoverservicingPrice'] ??
            0.0;
        final discount = carData['discount'] ?? '';
        final image = carData['image'];
        final mainCategory=carData['mainCategory']??
            '';
        return Stack(
            children: [                                    // Container for the tire information
                                    Container(
                                      margin: EdgeInsets.fromLTRB(7, 8, 7, 8),
                                      height: 110,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
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
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 17),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 70, // Adjust the height as needed
                                                    child: CircleAvatar(
                                                      radius: 30, // Adjust the radius as needed
                                                      backgroundImage: NetworkImage(image),
                                                    ),
                                                  ),
                                                  SizedBox(width: 7),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '$servicingOption',
                                                            style: Theme.of(context).textTheme.caption!.copyWith(
                                                              fontWeight: FontWeight.bold,
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
                                                                  style: Theme.of(context).textTheme.caption!.copyWith(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 15,
                                                                  ),
                                                                ),]),
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
                                          ] ),
                                    ),
                                    // Heart icon for marking as favorite (top right corner)
                                    Positioned(
                                        top: 17,
                                        right: 15,
                                        child:Row(
                                            children:[
                                              Text('$discount Off'),

                                            ])
                                    ),
                                    Positioned(
                                      bottom: 9,
                                      right: 8,
                                      child: Container(
                                          height: 35,
                                          width: 130,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryMaterialColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(11.0),
                                              bottomRight:Radius.circular(11.0), // You can adjust the radius as needed
                                            ),
                                          ),
                                          child:InkWell(
                                            onTap: (){
                                              Get.to(() =>  allDetailingDetails(
                                                  serviceType: serviceType,
                                                  servicingOption:servicingOption,
                                                  hatchbackPrice: hatchbackPrice,
                                                  sedanPrice: sedanPrice,
                                                  crossoverPrice: crossoverPrice,
                                                  discount: discount,
                                                  image:image,
                                                  description:description,
                                                  mainCategory:mainCategory
                                              ),
                                                  transition: Transition.fade,
                                                  duration: const Duration(seconds: 1));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Row(
                                                  children:[
                                                    FaIcon(
                                                      (FontAwesomeIcons.cartShopping),
                                                      color:Colors.white, // You can set the desired color
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text('Buy Now',style: TextStyle(
                                                        color: Colors.white
                                                    ),),
                                                  ]),
                                            ),
                                          )
                                      ),
                                    ),
                                  ]
                              );
                            },
                          )
          )
  ]),
        )
    );
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }
}

