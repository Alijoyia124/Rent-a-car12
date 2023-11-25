class Booking {
  final String carName;
  final DateTime pickupDateTime;
  final DateTime returnDateTime;
  final String selectedShop;
  final String image;
  String? bookingId;
  final String carModel;
  final double rent;
  final String username; // Add this line


  Booking({
    required this.carName,
    required this.pickupDateTime,
    required this.returnDateTime,
    required this.selectedShop,
    required this.carModel,
    required this.rent,
    required this.username,
    required this.image,
    this.bookingId, // Add this line to initialize the bookingId property

  });

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'carName': carName,
      'carModel': carModel,
      'pickupDateTime': pickupDateTime,
      'returnDateTime': returnDateTime,
      'selectedShop': selectedShop,
       'rent':rent,
      'username':username,
      'imageUrl':image,
    };
  }
}
