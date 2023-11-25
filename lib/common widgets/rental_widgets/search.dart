import 'package:flutter/material.dart';

import '../../features/Authentication/Controllers/carController.dart';
import '../../features/Authentication/screens/car_rental/cardetails/detail_cars.dart';

class CarSearch extends SearchDelegate<String> {
  final List<Car> carList;

  CarSearch(this.carList);

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the search bar (e.g., clear query)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the search bar (e.g., back button)
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show search results based on the entered query
    final results = carList.where((car) =>
        car.name.toLowerCase().contains(query.toLowerCase())).toList();

    return buildCarList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show search suggestions as the user types
    final suggestions = carList.where((car) =>
        car.name.toLowerCase().contains(query.toLowerCase())).toList();

    return buildCarList(suggestions);
  }

  Widget buildCarList(List<Car> cars) {
    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];

        return ClipRRect(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SearchResultCard(car: car),
          ),
        );
      },
    );
  }
}
class SearchResultCard extends StatefulWidget {
  final Car car;

  SearchResultCard({required this.car});

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          elevation: 4.0,
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Image.network(
                      widget.car.image,
                      fit: BoxFit.cover,
                      height: 250.0,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.car.name}',
                            style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            'Model: ${widget.car.model}',
                            style: Theme.of(context).textTheme.caption!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Car Manufacturer: ${widget.car.manufacturer}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 6,
                right: 10,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });

                        if (isFavorite) {
                          // Implement your logic to add the car to favorites
                        } else {
                          // Implement your logic to remove the car from favorites
                        }
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 2,
                right: 10,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarDetailsPage(
                                carName: widget.car.name,
                                carModel: widget.car.model,
                                carManufacturer: widget.car.manufacturer,
                                image: widget.car.image,
                                description: widget.car.description,
                                rentPerDay: widget.car.rentPerDay,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: Text("Details"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}