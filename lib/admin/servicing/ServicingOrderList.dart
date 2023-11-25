import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServicingOrderList extends StatefulWidget {
  const ServicingOrderList({Key? key}) : super(key: key);
  @override
  State<ServicingOrderList> createState() => _ServicingOrderListState();
}
class _ServicingOrderListState extends State<ServicingOrderList> {
  bool isDeleting = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> deleteOrder(String documentId) async {
    try {
      // Delete the order from Firestore
      await _firestore.collection('booked_carServicing').doc(documentId).delete();
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
          title: Text("Servicing Orders"),
        ),
        body: RefreshIndicator(
            onRefresh: _refreshData,
            child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('booked_carServicing')
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
                      child: Text('No Servicing orders available.'),
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
                              title: Text('${bookingData['carName']} (${bookingData['carType']})',style: Theme.of(context).textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.bold
                              ),),
                              subtitle: Text(
                                'Registration Number : ${bookingData['registrationNumber']}\n'
                                    'Service Category : ${bookingData['servicingOption']} (${bookingData['serviceType']})\n'
                                    'Price : ${bookingData['price']}\n'
                                    'selectedYear : ${bookingData['manufacturingYear']}\n'
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