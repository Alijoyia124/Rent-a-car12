import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TyreSearchController {
  List<DocumentSnapshot> filterData(AsyncSnapshot<QuerySnapshot> snapshot, String query) {
    final filteredData = <DocumentSnapshot>[];

    if (query.isEmpty) {
      filteredData.addAll(snapshot.data?.docs ?? []);
    } else {
      filteredData.addAll(snapshot.data?.docs.where((document) {
        final carData = document.data() as Map<String, dynamic>;
        final carModel = carData['category'] ?? '';
        return carModel.toLowerCase().contains(query.toLowerCase());
      }).toList() ?? []);
    }

    return filteredData;
  }
}
