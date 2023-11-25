import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServiceCenters extends StatefulWidget {
  const ServiceCenters({Key? key}) : super(key: key);

  @override
  State<ServiceCenters> createState() => _ServiceCentersState();
}

class _ServiceCentersState extends State<ServiceCenters> {
  bool isSavingData = false;
  String imageUrl='';


  final _formKey = GlobalKey<FormState>();
  final storenameController=TextEditingController();
  final addressController=TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  final storenameFocusNode=FocusNode();
  final addressFocusNode=FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Service Centers"),
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

              return Container(
                margin: EdgeInsets.fromLTRB(25, 11, 25, 11),
                height: 250,
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 120, // Half of the total height
                      child: Image.network(image, fit: BoxFit.cover),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$storename',
                              style: Theme.of(context).textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Address:',
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text('$address'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
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