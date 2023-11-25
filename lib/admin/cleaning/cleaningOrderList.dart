import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CleaningOrderList extends StatefulWidget {
  const CleaningOrderList({Key? key}) : super(key: key);

  @override
  State<CleaningOrderList> createState() => _CleaningOrderListState();
}

class _CleaningOrderListState extends State<CleaningOrderList> {
  bool isDeleting = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteOrder(String documentId) async {
    try {
      // Delete the order from Firestore
      await _firestore.collection('bookings').doc(documentId).delete();
    } catch (e) {
      print('Error deleting order: $e');
    }
  }
  Future<void> _refreshData() async {
    // Add logic to refresh the data from Firestore here
    // For example, you can re-fetch the data or update your state
    setState(() {
      // Update your state here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Cleaning Orders"),
    ),
    body: RefreshIndicator(
    onRefresh: _refreshData,
    child: StreamBuilder<QuerySnapshot>(
    stream: _firestore
        .collection('bookings')
        .where('mainCategory', isEqualTo: 'Cleaning')
        .snapshots(),
    builder: (context, snapshot) { {
    if (!snapshot.hasData) {
    return Center(
    child: CircularProgressIndicator(),
    );
    }

    final docs = snapshot.data!.docs;

    if (docs.isEmpty) {
    return Center(
    child: Text('No cleaning orders available.'),
    );
    }

    return ListView.builder(
    itemCount: docs.length,
    itemBuilder: (context, index) {
    final documentId = docs[index].id;
    final bookingData = docs[index].data() as Map<String, dynamic>;

    return Column(
    children: <Widget>[
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
      title: Text('${bookingData['carModel']} (${bookingData['carType']})',style: Theme.of(context).textTheme.headline6!.copyWith(
        fontWeight: FontWeight.bold
      ),),
      subtitle: Text(
      'Registration Number : ${bookingData['registrationNumber']}\n'
      'Service Category : ${bookingData['ServiceCategory']}\n'
      'Cost : ${bookingData['price']}\n'
      'Ordered by : ${bookingData['username']} (${bookingData['phone']})',
      ),
      trailing:isDeleting
          ? CircularProgressIndicator() // Loading indicator
          : IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          // Trigger the delete operation when the delete icon is pressed
          deleteOrder(documentId);
        },
      ),
      ),
    ),
    Divider(
    height: 1,
    color: Colors.black,
    ),
    ],
    );
    },
    );
    }})
    ));
  }}