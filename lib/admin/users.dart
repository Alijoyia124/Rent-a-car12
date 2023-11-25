import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class users extends StatefulWidget {
  const users({Key? key}) : super(key: key);

  @override
  State<users> createState() => _usersState();
}

class _usersState extends State<users> {
  late List<Map<String, dynamic>> userRecords = [];

  Future<void> fetchUserRecords() async {
    try {
      // Get a reference to the Firestore collection where user records are stored
      CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

      // Fetch all user records
      QuerySnapshot querySnapshot = await usersCollection.get();

      // Clear the existing user records
      userRecords.clear();

      // Loop through the documents in the collection and add them to the list
      querySnapshot.docs.forEach((doc) {
        // Access user data using doc.data() and add it to the list
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        userRecords.add(userData);
      });

      // Trigger a UI update
      setState(() {});
    } catch (e) {
      // Handle errors, e.g., Firestore not initialized or permission denied
      print('Error fetching user records: $e');
    }
  }

  Future<void> deleteUserRecord(int index) async {
    try {
      // Check if the userRecords list has the specified index
      if (index >= 0 && index < userRecords.length) {
        // Get the document ID of the user to be deleted
        String? userId = userRecords[index]['id'];

        // Check if userId is not null before deleting
        if (userId != null) {
          // Remove the user record from Firestore
          await FirebaseFirestore.instance.collection('users').doc(userId).delete();

          // Remove the user record from the UI
          userRecords.removeAt(index);

          // Trigger a UI update
          setState(() {});
        }
      }
    } catch (e) {
      print('Error deleting user record: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Records'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                fetchUserRecords(); // Call the method when the button is pressed
              },
              child: Text('Fetch User Records'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: userRecords.length,
                itemBuilder: (context, index) {
                  final userData = userRecords[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('User ID: ${userData['email']}'),
                      subtitle: Text('User Name: ${userData['username']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Call the delete function when the delete icon is pressed
                          deleteUserRecord(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
