import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingListPage extends StatefulWidget {
    final List<Map<String, dynamic>> bookings; // List of booking data

    BookingListPage({required this.bookings});

    @override
    _BookingListPageState createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
    List<Map<String, dynamic>> allBookings = [];

    @override
    void initState() {
        super.initState();
        fetchBookings();
    }

    Future<void> fetchBookings() async {
        try {
            final querySnapshot = await FirebaseFirestore.instance.collection('bookings').get();
            querySnapshot.docs.forEach((bookingDoc) async {
                final tyreQuerySnapshot = await bookingDoc.reference.collection('tyres').get();
                tyreQuerySnapshot.docs.forEach((tyreDoc) {
                    setState(() {
                        allBookings.add(tyreDoc.data() as Map<String, dynamic>);
                    });
                });
            });
        } catch (e) {
            print('Error fetching bookings: $e');
        }
    }

    Future<void> deleteBookingData(String bookingId, String tyreId) async {
        try {
            final firestore = FirebaseFirestore.instance;
            // Delete the Firestore document using the bookingId and tyreId
            await firestore
                .collection('bookings')
                .doc(bookingId)
                .collection('tyres')
                .doc(tyreId)
                .delete();

            // Remove the booking locally by removing it from the list
            setState(() {
                allBookings.removeWhere(
                        (booking) => booking['bookingId'] == bookingId && booking['tireId'] == tyreId);
            });

            // You can also remove the booking from your local list (widget.bookings) if needed
            widget.bookings.removeWhere(
                    (booking) => booking['bookingId'] == bookingId && booking['tireId'] == tyreId);
        } catch (e) {
            // Handle errors if any
            print('Error deleting booking data: $e');
            // Show an error message to the user if needed
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Booking List'),
            ),
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    children: [
                        Expanded(
                            child: SingleChildScrollView(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: allBookings.length,
                                    itemBuilder: (context, index) {
                                        final booking = allBookings[index];
                                        final bookingId = booking['bookingId'];
                                        final tyreId = booking['tireId']; // Replace 'id' with the actual field name in your Firestore document

                                        return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            child: Container(
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.black),
                                                    borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: ListTile(
                                                    leading: CircleAvatar(
                                                        child: Image.asset("your_image_asset_here.png"), // Replace with your image asset
                                                    ),
                                                    title: Text('Car Model: ${booking['carModel']}'),
                                                    subtitle: Text('Car Year: ${booking['carYear']}'),
                                                    trailing: IconButton(
                                                        icon: Icon(Icons.delete),
                                                        onPressed: () {
                                                            // Delete the booking when the delete icon is tapped
                                                            deleteBookingData(bookingId, tyreId);
                                                        },
                                                    ),
                                                ),
                                            ),
                                        );
                                    },
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
