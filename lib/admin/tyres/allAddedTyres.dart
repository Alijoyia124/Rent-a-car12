import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../resources/color.dart';

class allTyresAdmin extends StatefulWidget {
  const allTyresAdmin({Key? key}) : super(key: key);

  @override
  State<allTyresAdmin> createState() => _allTyresAdminState();
}

class _allTyresAdminState extends State<allTyresAdmin> {

  TextEditingController _carModelController = TextEditingController();
  TextEditingController _carManufacturerController = TextEditingController();
  TextEditingController _tyreSizeController = TextEditingController();
  TextEditingController _tyrePriceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();


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
                  controller: _carModelController,
                  decoration: InputDecoration(labelText: 'Tyre Name'),
                ),
                TextFormField(
                  controller: _discountController,
                  decoration: InputDecoration(labelText: 'Discount'),
                ),
                TextFormField(
                  controller: _tyreSizeController,
                  decoration: InputDecoration(labelText: 'Tyre Size'),
                ),
                TextFormField(
                  controller: _tyrePriceController,
                  decoration: InputDecoration(labelText: 'Tyre Price'),
                ),
                TextFormField(
                  controller: _discountController,
                  decoration: InputDecoration(labelText: 'Rent per Day'),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Car Description'),
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
      final carRef = FirebaseFirestore.instance.collection('addTyreAdmin').doc(carId);
      await carRef.update({
        'carName': _carModelController.text,
        'carManufacturer': _carManufacturerController.text,
        'tyreSize': _tyreSizeController.text,
        'tyrePrice': double.parse(_tyrePriceController.text),
        'discount': _discountController.text,
        'description': _descriptionController.text,
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Tyres"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('addTyreAdmin').snapshots(),
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
    final carModel = carData['carModel'] ?? '';
    final carManufacturer = carData['carManufacturer'] ?? '';
    final tyreSize = carData['tyreSize'] ?? 0.0;
    final tyrePrice = carData['tyrePrice'] ?? 0.0;
    final discount = carData['discount'] ?? '';
    final category = carData['category'] ?? '';
    final description = carData['description'] ?? '';
    return Container(
    margin: EdgeInsets.fromLTRB(25, 11, 25, 11),
        height: 350,
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
    padding: const EdgeInsets.all(20.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    'Brand Name:   $category',
    style: Theme.of(context).textTheme.headline6!.copyWith(
    fontWeight: FontWeight.bold,
    ),
    ),]),
    Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    IconButton(
    icon: FaIcon(FontAwesomeIcons.edit,size: 17,color: AppColors.primaryMaterialColor,),
    onPressed: () {
    // Pre-fill the edit form with existing details
    _carModelController.text = carModel;
    _carManufacturerController.text = carManufacturer;
    _tyreSizeController.text = tyreSize.toString();
    _tyrePriceController.text = tyrePrice.toString();
    _discountController.text = discount;
    _descriptionController.text = description;

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
    await FirebaseFirestore.instance.collection('addTyreAdmin').doc(tyreDocument.id).delete();
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
    await FirebaseFirestore.instance.collection('addTyreAdmin').doc(tyreDocument.id).delete();
    }
    },
    ),

    ],
    ),

    SizedBox(height: 5),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children:[
    Row(
    children:[
    Column(
    children:[
    Text('Tyre Size',style: Theme.of(context).textTheme.caption!.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 15),),
    Text('$tyreSize'),
    ])]),
    Row(
    children:[
    Column(
    children:[
    Text('Tyre Price',style: Theme.of(context).textTheme.caption!.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 15
    ),),
    Text('$tyrePrice'),


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
SizedBox(height: 7,),

      Text('Description: ',style: Theme.of(context).textTheme.caption!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 15),),
     Text(
          '$description',
       maxLines: 9,
        ),

          ])
    )]),
    );

            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _carModelController.dispose();
    _carManufacturerController.dispose();
    _tyreSizeController.dispose();
    _tyrePriceController.dispose();
    _discountController.dispose();
    super.dispose();
  }
}
