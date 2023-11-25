// import 'package:flutter/material.dart';
// import '../../../../../../common widgets/horizontal_view/horizontalview.dart';
// import '../../../../../../resources/color.dart';
// import '../bodyWork/allProductDetailPage.dart';
// import '../products.dart';
//
// class carRepairs extends StatefulWidget {
//   const carRepairs({Key? key}) : super(key: key);
//
//   @override
//   State<carRepairs> createState() => _carRepairsState();
// }
//
// class _carRepairsState extends State<carRepairs> {
//
//   final List<Product> products = [
//     Product(
//       name: "Penal Painting",
//       description: "Description for Product 1",
//       imageAsset: "assets/images/painting.jpg",
//       category: "Car Spraying",
//     ),
//     Product(
//       name: "Underbody Painting",
//       description: "Description for Product 2",
//       imageAsset: "images/services/underbodyPainting.jpg",
//       category: "Car Spraying",
//     ),
//
//     Product(
//       name: "Car Rust Removal",
//       description: "Description for Product 1",
//       imageAsset: "images/services/underbody2.jpg",
//       category: "Car Rust Removal",
//     ),
//     Product(
//       name: "Dent Removal",
//       description: "Description for Product 1",
//       imageAsset: "assets/images/dentRemoval.jpg",
//       category: "Dent Removal",
//     ),
//
//   ];
//
//   String selectedCategory = "View All"; // To track the selected category
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> categoryNames = [
//       "View All",
//       "Car Spraying",
//       "Rust Work",
//       "Dent Removal",
//       "Car Restoration"
//       // Add more category names as needed
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Car Repairs",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: AppColors.primaryMaterialColor,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               CategoryScroll(
//                 categoryNames: categoryNames,
//                 selectedCategory: selectedCategory,
//                 onTapCategory: (categoryName) {
//                   setState(() {
//                     selectedCategory = categoryName;
//                   });
//                 },
//               ),
//               // Display products based on the selected category
//               buildProductList(selectedCategory),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Function to build the product list based on the selected category
//   Widget buildProductList(String selectedCategory) {
//     // Filter products based on the selected category
//     List<Product> filteredProducts;
//
//     if (selectedCategory == "View All") {
//       // Display all products when "View All" is selected
//       filteredProducts = products;
//     } else {
//       // Display products that belong to the selected category
//       filteredProducts = products
//           .where((product) => product.category == selectedCategory)
//           .toList();
//     }
//
//     // Build the product list using ListView.builder
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: filteredProducts.length,
//       itemBuilder: (context, index) {
//         final product = filteredProducts[index];
//
//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           child: GestureDetector(
//             onTap: () {
//               // Navigate to the product detail page when a product is tapped
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => ProductDetailPage(product: product),
//                 ),
//               );
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.black),
//               ),
//               height: 125,
//               child: Align(
//                 alignment: Alignment.center,
//                 child: ListTile(
//                   title: Text(
//                     product.name,
//                     style: Theme.of(context).textTheme.headline6!.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   subtitle: Text(product.description),
//                   leading: CircleAvatar(child: Image.asset(product.imageAsset)),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }