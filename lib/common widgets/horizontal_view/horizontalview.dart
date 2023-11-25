import 'package:covid_tracker/resources/color.dart';
import 'package:flutter/material.dart';

import '../../features/Authentication/screens/car_servicing/services/products.dart';


class CategoryScroll extends StatelessWidget {
  final List<String> categoryNames;
  final Function(String categoryName) onTapCategory;
  final String selectedCategory;

  CategoryScroll({required this.categoryNames, required this.onTapCategory, required this.selectedCategory,});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
        categoryNames.map((categoryName) {
          return CategoryItem(
            categoryName: categoryName,
            onTapCategory: onTapCategory,
            isSelected: categoryName == selectedCategory, // Check if it's selected
          );
        }).toList(),

      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String categoryName;
  final Function(String categoryName) onTapCategory;
  final bool isSelected; // Add a isSelected property

  CategoryItem({
    required this.categoryName,
    required this.onTapCategory,
    required this.isSelected, // Pass isSelected as a parameter
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          onTapCategory(categoryName);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 7,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? AppColors.primaryMaterialColor: Colors.black, // Change background color when isSelected is true
          ),
          child: Text(
            categoryName,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white, // Change text color when isSelected is true
            ),
          ),
        ),
      ),
    );
  }
}
class ProductList extends StatelessWidget {
  final String selectedCategory;
  final List<Product> products;

  ProductList(this.selectedCategory, this.products);

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts;

    // Filter products based on the selected category
    if (selectedCategory == "View All") {
      // Display all products when "View All" is selected
      filteredProducts = products;
    } else {
      // Display products that belong to the selected category
      filteredProducts = products
          .where((product) => product.category == selectedCategory)
          .toList();
    }

    return Column(
      children: filteredProducts.map((product) {
        return buildProductContainer(product);
      }).toList(),
    );
  }

  Widget buildProductContainer(Product product) {
    return Column(
    children:[
       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 5),
         child: FractionallySizedBox(
          widthFactor: 1.0,
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black87,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  child: Image.asset(
                    product.imageAsset,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        product.description,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
       ),

    ]);
  }
}
