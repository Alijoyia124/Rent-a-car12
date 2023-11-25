import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../resources/color.dart';


class allStores extends StatefulWidget {
  const allStores({Key? key}) : super(key: key);

  @override
  State<allStores> createState() => _allStoresState();
}

class _allStoresState extends State<allStores> {
  bool isSavingData = false;
  String imageUrl='';


  final _formKey = GlobalKey<FormState>();
  final storenameController=TextEditingController();
  final addressController=TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  final storenameFocusNode=FocusNode();
  final addressFocusNode=FocusNode();



  void  _editdetailingDetails(String carId) async {
    final shouldEdit = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Detailing Details'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: storenameController,
                  decoration: InputDecoration(labelText: 'Storename'),
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
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
      final carRef = FirebaseFirestore.instance.collection('addServiceCenterAdmin').doc(carId);
      await carRef.update({
        'storename':storenameController.text,
        'address': addressController.text,
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Detailing Services"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('addServiceCenterAdmin').snapshots(),
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
              final detailingDocument = snapshot.data!.docs[index];
              final carData = detailingDocument.data() as Map<String, dynamic>;

              final storename = carData['storename'] ?? '';
              final address = carData['address'] ?? '';
              final image = carData['image'];

              return Stack(
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(25, 11, 25, 11),
                        height: 220,
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
                                              Text(
                                                '$storename',
                                                style: Theme.of(context).textTheme.headline6!.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),]),
                                        Text('Address:',style: Theme.of(context).textTheme.caption!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                        Text('$address')
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

                                  storenameController.text = storename;
                                  addressController.text = address;

                                  // Call the _editCarDetails function
                                  _editdetailingDetails(detailingDocument.id);
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
                                              await FirebaseFirestore.instance.collection('addServiceCenterAdmin').doc(detailingDocument.id).delete();
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
                                    await FirebaseFirestore.instance.collection('addCleaningAdmin').doc(detailingDocument.id).delete();
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
    storenameController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
