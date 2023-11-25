import 'package:flutter/foundation.dart';

class ServiceData extends ChangeNotifier {
  // Define variables to store the data you need, such as servicingPrice, discount, description, etc.
  double servicingPrice;
  String discount;
  String description;

  ServiceData({
    required this.servicingPrice,
    required this.discount,
    required this.description,
  });

  // Add methods to update the data if needed

  // Create a factory constructor to create an instance of the ServiceData class
  factory ServiceData.initial() {
    return ServiceData(
      servicingPrice: 0.0,
      discount: '',
      description: '',
    );
  }
}
