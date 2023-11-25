import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TyreOrderItem extends StatefulWidget {
  final Map<String, dynamic> order;
  final Function onDelete;

  TyreOrderItem({
    required this.order,
    required this.onDelete,
  });

  @override
  _TyreOrderItemState createState() => _TyreOrderItemState();
}

class _TyreOrderItemState extends State<TyreOrderItem> {
  bool isDeleting = false;

  Future<void> deleteOrder() async {
    // Set isDeleting to true to show a loading indicator
    setState(() {
      isDeleting = true;
    });

    try {
      // Perform the delete operation in Firestore using the documentId
      // Replace 'yourCollection' with the actual name of your Firestore collection
      await FirebaseFirestore.instance.collection('booked_tyres').doc(widget.order['id']).delete();

      // Trigger the onDelete callback provided by the parent widget
      widget.onDelete();
    } catch (e) {
      print('Error deleting order: $e');
    } finally {
      // Regardless of success or error, set isDeleting to false here
      setState(() {
        isDeleting = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final documentId = order['tyreid']; // Replace with your actual field name

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(
              '${order['category']}, Quantity: ${order['quantity']}',
              style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Tire Size: ${order['tyreSize']}\nOrdered By: ${order['username']}'),
            trailing: isDeleting
                ? CircularProgressIndicator() // Loading indicator
                : IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Trigger the delete operation when the delete icon is pressed
                deleteOrder();
              },
            ),
          ),
        ),
        Divider(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}

class TyreOrdersList extends StatefulWidget {
  final List<Map<String, dynamic>> orders;

  TyreOrdersList({required this.orders});

  @override
  _TyreOrdersListState createState() => _TyreOrdersListState();
}

class _TyreOrdersListState extends State<TyreOrdersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tyre Orders"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Add logic to refresh the orders here, e.g., retrieve them again from Firebase
          // For simplicity, I'll just delay the refresh for 2 seconds to simulate a refresh
          await Future.delayed(Duration(seconds: 2));

          // Trigger a rebuild of the UI by calling setState
          setState(() {});
        },
        child: ListView.builder(
          itemCount: widget.orders.length,
          itemBuilder: (context, index) {
            final order = widget.orders[index];

            return TyreOrderItem(
              order: order,
              onDelete: () {
                // Remove the order from the local list
                setState(() {
                  widget.orders.removeAt(index);
                });

                // Show a SnackBar to provide feedback to the user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Order deleted."),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}