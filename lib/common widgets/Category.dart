import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String name;
  final String image;

  const Category({
    required this.name,
    required this.image,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [name, image];

  static List<Category> categories = [
    const Category(
      name: 'Detailing',
      image: "images/services/mainPageImages/post_06-1280x1280.jpg",
    ),
    const Category(
      name: 'Inspection Services',
      image: "images/services/mainPageImages/home3-bg-05.jpg",
    ),
    const Category(
      name: 'Engine Upgrading',
      image: "images/services/mainPageImages/home3-bg-06.jpg",
    ),
    const Category(
      name: 'Denting & Penting',
      image: "images/services/mainPageImages/post_05-1280x1280.jpg",
    ),
  ];
}
