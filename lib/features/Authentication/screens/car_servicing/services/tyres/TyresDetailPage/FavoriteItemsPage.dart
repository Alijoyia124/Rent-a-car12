import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteItemsPage extends StatefulWidget {
  final String username;

  FavoriteItemsPage({required this.username});

  @override
  _FavoriteItemsPageState createState() => _FavoriteItemsPageState();
}

class _FavoriteItemsPageState extends State<FavoriteItemsPage> {
  late List<DocumentSnapshot> favoriteItems;

  @override
  void initState() {
    super.initState();
    // Fetch the user's ID based on their name
    fetchUserId();
  }

  Future<void> fetchUserId() async {
    try {
      // Access the "users" collection in Firestore to get the user's ID
      var userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: widget.username)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        var userDocument = userQuery.docs.first;
        var userId = userDocument.id;

        // Fetch the user's favorite items using the user's ID
        fetchFavoriteItems(userId);
      } else {
        print('User not found');
      }
    } catch (error) {
      print("Error fetching user ID: $error");
    }
  }

  Future<void> fetchFavoriteItems(String userId) async {
    try {
      // Access the "favorites" collection in Firestore for the specific user
      var favoritesSnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .doc(userId)
          .collection('items')
          .get();

      // Update the state with the list of favorite items
      setState(() {
        favoriteItems = favoritesSnapshot.docs;
      });
    } catch (error) {
      print("Error fetching favorite items: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Items'),
      ),
      body: Column(
        children: [
          // Display the count of favorite items
          Text('Favorite Items Count: ${favoriteItems.length}'),
          // Display the list of favorite items
          Expanded(
            child: ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                var item = favoriteItems[index];
                // Customize the widget to display each favorite item
                return ListTile(
                  title: Text(item['itemName']),
                  // Add more details if needed
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
