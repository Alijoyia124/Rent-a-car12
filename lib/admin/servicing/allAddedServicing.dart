
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../features/Authentication/Controllers/service.dart';
import '../../resources/color.dart';

class allAddedServices extends StatefulWidget {
  const allAddedServices({Key? key}) : super(key: key);

  @override
  State<allAddedServices> createState() => _allAddedServicesState();
}

class _allAddedServicesState extends State<allAddedServices> {

  TextEditingController _servicingPriceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();



  void _editTyreDetails(String carId) async {
    final shouldEdit = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Car Details'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _servicingPriceController,
                  decoration: InputDecoration(labelText: 'Servicing Price'),
                ),
                TextFormField(
                  controller: _discountController,
                  decoration: InputDecoration(labelText: 'Discount'),
                ),

                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),

                // TextFormField(
                //   controller: _tyrePriceController,
                //   decoration: InputDecoration(labelText: 'Tyre Price'),
                // ),
                // TextFormField(
                //   controller: _discountController,
                //   decoration: InputDecoration(labelText: 'Rent per Day'),
                // ),
                // TextFormField(
                //   controller: _descriptionController,
                //   decoration: InputDecoration(labelText: 'Car Description'),
                // ),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('SAVE'),
            ),
          ],
        );
      },
    );

    if (shouldEdit == true) {
      // Update the car details in Firebase
      final carRef = FirebaseFirestore.instance.collection('addServicingAdmin').doc(carId);
      await carRef.update({

        'servicingPrice': double.parse(_servicingPriceController.text),
        'discount': _discountController.text,
        'description': descriptionController.text,

      });
    }
  }


  final CollectionReference _servicesCollection =
  FirebaseFirestore.instance.collection('addServicingAdmin');

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Services"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _servicesCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final serviceDocument = snapshot.data!.docs[index];
              final carData = serviceDocument.data() as Map<String, dynamic>;

              final serviceType = carData['serviceType'] ?? '';
              final servicingOption = carData['servicingOption'] ?? '';
              final sedanservicingPrice = carData['sedanservicingPrice'] ?? 0.0;
              final discount = carData['discount'] ?? '';
              final description = carData['description'] ?? '';
              final image = carData['image'];

              return Stack(
                  children: [
                    Container(
                    margin: EdgeInsets.fromLTRB(25, 11, 25, 11),
                        height: 270,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:Colors.white70,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2), // Color of the shadow
                              spreadRadius: 2, // Spread radius
                              blurRadius: 2, // Blur radius
                              offset: Offset(0, 3), // Offset in the x, y direction
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 18),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            children: [
                                              Container(
                                                height: 70, // Adjust the height as needed
                                                child: CircleAvatar(
                                                  radius: 30, // Adjust the radius as needed
                                                  backgroundImage: NetworkImage(image),
                                                ),
                                              ),

                                              SizedBox(width: 8),
              Text('$serviceType', style: Theme.of(context).textTheme.headline6!.copyWith(
              fontWeight: FontWeight.bold,
              )),]),


                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children:[
                                              Row(
                                                  children:[
                                                    Text('Sub Type : $servicingOption'),

                                                    ]),
                                                   ]),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children:[
                                                    Column(
                                                        children:[
                                                          Text('Discount',style: Theme.of(context).textTheme.caption!.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 15),),
                                                          Text('$discount'),
                                                        ]),
                                                    Column(
                                                        children:[
                                                          Text('Price',style: Theme.of(context).textTheme.caption!.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 15),),
                                                          Text('$sedanservicingPrice'),
                                                        ])
                                                  ]),

                                              // Text('Discount: $discount'),.................................;...;;.............................................................................................................



                                        Text('Description:',style: Theme.of(context).textTheme.caption!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                        Text('$description')
                                      ])
                              )])
                    ),


                    Positioned(
                        top: 15,
                        right: 22,
                        child:Row(
                            children:[
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.edit,size: 17,color: AppColors.primaryMaterialColor,),
                                onPressed: () {
                                  // Pre-fill the edit form with existing details

                                  _servicingPriceController.text = sedanservicingPrice.toString();
                                  _discountController.text = discount;
                                  descriptionController.text = description;

                                  // Call the _editCarDetails function
                                  _editTyreDetails(serviceDocument.id);
                                },
                              ),
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.deleteLeft,size: 17,color: AppColors.primaryMaterialColor,),
                                onPressed: () async {
                                  // Show a confirmation dialog for delete
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirm Deletion'),
                                        content: Text('Are you sure you want to delete this car?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: Text('CANCEL'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              // Delete the tire record if the user confirmed
                                              await FirebaseFirestore.instance.collection('addServicingAdmin').doc(serviceDocument.id).delete();
                                              Navigator.of(context).pop(true);

                                            },
                                            child: Text('DELETE'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (shouldDelete == true) {
                                    // Delete the car record if the user confirmed
                                    await FirebaseFirestore.instance.collection('addServicingAdmin').doc(serviceDocument.id).delete();
                                  }
                                },
                              ),

                            ])
                    ),





                  ]  );

            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    _servicingPriceController.dispose();
    _discountController.dispose();
    super.dispose();
  }
}
