class Car {
  final String id; // Unique identifier, e.g., Firestore document ID
  final String name;
  final String model;
  final String manufacturer;
  final String image;
  final String description;
  final double rentPerDay;

  Car({
    required this.id,
    required this.name,
    required this.model,
    required this.manufacturer,
    required this.image,
    required this.description,
    required this.rentPerDay,


  });
}
