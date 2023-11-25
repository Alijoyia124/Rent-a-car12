
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../resources/color.dart';

class allCleaningServices extends StatefulWidget {
  const allCleaningServices({Key? key}) : super(key: key);

  @override
  State<allCleaningServices> createState() => _allCleaningServicesState();
}

class _allCleaningServicesState extends State<allCleaningServices> {

  TextEditingController _cleaningPriceController = TextEditingController();
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
                  controller: _cleaningPriceController,
                  decoration: InputDecoration(labelText: 'Cleaning Price'),
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
      final carRef = FirebaseFirestore.instance.collection('addCleaningAdmin').doc(carId);
      await carRef.update({

        'cleaningPrice': double.parse(_cleaningPriceController.text),
        'discount': _discountController.text,
        'description': descriptionController.text,
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Cleaning Services"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('addCleaningAdmin').snapshots(),
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
              final tyreDocument = snapshot.data!.docs[index];
              final carData = tyreDocument.data() as Map<String, dynamic>;

              final sedanservicingPrice = carData['sedanservicingPrice'] ?? 0.0;
              final discount = carData['discount'] ?? '';
              final servicingOption = carData['servicingOption'] ?? '';
              final description = carData['description'] ?? '';
              final image = carData['image'];

              return Stack(
                  children: [
                    Container(
                    margin: EdgeInsets.fromLTRB(25, 11, 25, 11),
                height: 300,
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
                                        '$servicingOption',
                                        style: Theme.of(context).textTheme.headline6!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),]),


                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:[
                                      Row(
                                          children:[
                                            Column(
                                                children:[
                                                  Text('Price',style: Theme.of(context).textTheme.caption!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),),
                                                  Text('$sedanservicingPrice'),
                                                ])]),
                                      Row(
                                          children:[
                                            Column(
                                                children:[
                                                  Text('Discount',style: Theme.of(context).textTheme.caption!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),),
                                                  Text('$discount'),
                                                ])]),

                                      // Text('Discount: $discount'),.................................;...;;.............................................................................................................
                                    ]),


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

                                  _cleaningPriceController.text =sedanservicingPrice.toString();
                                  _discountController.text = discount;
                                  descriptionController.text = description;

                                  // Call the _editCarDetails function
                                  _editTyreDetails(tyreDocument.id);
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
                                              await FirebaseFirestore.instance.collection('addCleaningAdmin').doc(tyreDocument.id).delete();
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
                                    await FirebaseFirestore.instance.collection('addCleaningAdmin').doc(tyreDocument.id).delete();
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
    _cleaningPriceController.dispose();
    _discountController.dispose();
    super.dispose();
  }
}
