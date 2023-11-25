import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../common widgets/round_button.dart';
import '../../../../../resources/color.dart';
import 'serviceBookingSuccess.dart';

class BookingSummaryPage extends StatefulWidget {
  final String category;
  final String tyreSize;
  final double tyrePrice;
  final String discount;
  BookingSummaryPage({
    required this.category,
    required this.discount,
    required this.tyreSize,
    required this.tyrePrice,
  });
  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {

  int quantity = 1; // Initialize with a default quantity of 1
  bool isBooking = false;
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  User? user;
  String? userUID;
  String? username;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    if (user != null) {
      userUID = user!.uid;
      getUserUsername(user!.uid);
    }
  }
  Future<void> getUserUsername(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(
          userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          username = userData['username'] as String?;
        });
      }
    } catch (e) {
      print('Error retrieving username: $e');
    }
  }
  double calculateDiscountedPrice(double fullPrice, double discountPercentage, int quantity) {
    double discountAmount = (fullPrice * discountPercentage) / 100;
    double discountedPrice = fullPrice - discountAmount;
    return discountedPrice * quantity;
  }

  Future<void> submitBooking() async {
    setState(() {
      isBooking = true; // Show the circular indicator
    });
    String bookingId = DateTime.now().microsecondsSinceEpoch.toString();


    try {
      // Create a Firestore document with the selected details
      await firestore.collection('booked_tyres').doc(bookingId).set({
        'id':bookingId,
        'category': widget.category,
        'tyreSize': widget.tyreSize,
        'tyrePrice': widget.tyrePrice,
        'discount': widget.discount,
        'quantity': quantity,
        'username': username ?? 'N/A',
        'discountedPrice':
        calculateDiscountedPrice(widget.tyrePrice, double.parse(widget.discount), quantity),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => serviceSuccess(category: widget.category,tyreSize:widget.tyreSize),

        ),
      );

    } catch (e) {
      // Handle any errors that may occur during the submission process
      print('Error: $e');
    } finally {
      setState(() {
        isBooking = false; // Hide the circular indicator
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.tyrePrice * quantity;


    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Summary'),
      ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10,30,10,20),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 400,
                          decoration: BoxDecoration(
                            color:Colors.white70,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3), // Color of the shadow
                                spreadRadius: 3, // Spread radius
                                blurRadius: 4, // Blur radius
                                offset: Offset(0, 3), // Offset in the x, y direction
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                 // Use the imageUrl property from the Car object
                                  "assets/images/tyres/tyre2.png",
                                height: 80,
                                  width:90
                              ),
                              SizedBox(width: 40),
                              Text(
                                '${widget.category} ',
                                style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          width: 400,
                          decoration: BoxDecoration(
                            color: Colors.white70, // Set the inner content color to black
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey), // Border color
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3), // Color of the shadow
                                spreadRadius: 3, // Spread radius
                                blurRadius: 4, // Blur radius
                                offset: Offset(0, 3),// Adjust the spread radius as needed
                              ),
                            ],
                          ),



                          child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.start, // Align the contents to the start (left)
    children: [
    SizedBox(width: 8), // Adjust the width based on your preference

    ],
    ),

    SizedBox(height: 3),

    Row(
    mainAxisAlignment: MainAxisAlignment.start, // Align the contents to the start (left)
    children: [
    // Icon(FontAwesomeIcons.tire,size: 18,),
    SizedBox(width: 8), // Adjust the width based on your preference
    // Text(
    // 'Tires quantity  :  ${widget.quantity} ',
    // style: Theme.of(context).textTheme.caption!.copyWith(
    // fontWeight: FontWeight.bold,
    // fontSize: 16,
    // ),
    // )
    ],
    ),

      SizedBox(height: 8),

    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align the contents to the start (left)
    children: [
    Text(
    'Brand Name : ',
    style: Theme.of(context).textTheme.caption!.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    ),
    ),
      Text(
        '${widget.category}',
        style: Theme.of(context).textTheme.caption!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ],
    ),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align the contents to the start (left)
        children: [
          Text(
            'Tyre Size : ',
            style: Theme.of(context).textTheme.caption!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            '${widget.tyreSize}',
            style: Theme.of(context).textTheme.caption!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align the contents to the start (left)
        children: [
          Text(
            'Discount Given : ',
            style: Theme.of(context).textTheme.caption!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            '${widget.discount} %',
            style: Theme.of(context).textTheme.caption!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    SizedBox(height: 5,),

    // Text(
    // ' ${widget.returnDateTime != null ? DateFormat('EEE, MMM d, y AT HH:mm a').format(widget.returnDateTime!) : 'N/A'}',
    //
    // )
    ],
    ),
    ),
    ),
    SizedBox(height: 60,),
                  Row(
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                     Text('Quantity:',style: Theme.of(context).textTheme.caption!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        // Decrease the quantity by 1, but don't allow it to go below 1
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                      icon: Icon(Icons.remove),
                    ),
                    Text('$quantity'),
                    IconButton(
                      onPressed: () {
                        // Increase the quantity
                        setState(() {
                          quantity++;
                        });
                      },
                      icon:const Icon(Icons.add),
                    ),
                  ],
                ),


    SizedBox(
    height: 5, // Adjust the height as needed
    child: Divider(
    color: AppColors.primaryMaterialColor,
    ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 25),
      child: Container(
      child:Column(
      children:[
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
   Text('Tyre Price: ',style: Theme.of(context).textTheme.caption!.copyWith(
       fontWeight: FontWeight.bold,
       fontSize: 16,)),
        Text('Rs. ${widget.tyrePrice}')
      ],
      ),
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Text("Tyres Quantity : ",style: Theme.of(context).textTheme.caption!.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 16,)),
        Text('${quantity}')
      // Text('$rentalDays days'),
      ],
      ),
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Text("Total Payment : ",style: Theme.of(context).textTheme.caption!.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      ),),
        Text('Rs. $totalPrice',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 15,
                          decoration: TextDecoration.lineThrough,
                        ),)
      ],
      ),
        SizedBox(
          height: 5, // Adjust the height as needed
          child: Divider(
            color: AppColors.primaryMaterialColor,
          ),
        ),
        SizedBox(height: 40,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Discounted Price : ",style: Theme.of(context).textTheme.caption!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),),
            Text('Rs. ${calculateDiscountedPrice(widget.tyrePrice, double.parse(widget.discount), quantity).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: 15,
              ),
            ),

          ],
        ),
      SizedBox(height:90 ),

        isBooking
            ? CircularProgressIndicator() // Show circular indicator
            : RoundButton(
          title: 'Confirm',
          onPress: () async {
            await submitBooking();
            // You can use Navigator to navigate to a success page here if needed.
          },
        ),
    ])
    ))
    ])))));
  }
}
