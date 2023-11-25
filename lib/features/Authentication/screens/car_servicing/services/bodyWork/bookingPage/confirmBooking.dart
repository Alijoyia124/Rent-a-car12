import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../../../../common widgets/round_button.dart';
import '../../../../../../../resources/color.dart';
import 'bookingSucces.dart';

class ConfirmationBooking extends StatefulWidget {
  final String carType;
  final String carBrand;
  final String carModel;
  final String carName;
  final int? selectedYear;
  final String serviceType;
  final String servicingOption;
  final double price;
  final String phone;
  final DateTime pickupDateTime; // Receive the selected date and time

  ConfirmationBooking({
    Key? key,
    required this.carType,
    required this.carBrand,
    required this.carModel,
    required this.carName,
    required this.selectedYear,
    required this.serviceType,
    required this.servicingOption,
    required this.price,
    required this.pickupDateTime,
    required this.phone, // Receive the selected date and time
  }) : super(key: key);


  @override
  State<ConfirmationBooking> createState() => _ConfirmationBookingState();
}

class _ConfirmationBookingState extends State<ConfirmationBooking> {
  DateTime? pickupDateTime = DateTime.now();
  DateTime? returnDateTime = DateTime.now();
  DateTime? selectedDate;
  bool isSavingData = false;
  String? pickupDateAndTimeError;
  TimeOfDay? selectedTime;
  String selectedCarType = 'Sedan';
  String selectedCarBrand = 'Honda'; // Selected car brand
  String selectedCarModel = 'Honda City';
  double selectedServicePrice = 0.0; // Selected car model
  TextEditingController carNameController = TextEditingController();
  final carNameFocusNode=FocusNode();
  int? selectedYear;

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
  Future<void> saveServicingDataToFirestore() async {
    try {
      await Firebase.initializeApp(); // Initialize Firebase (ensure it's called only once)

      final firestore = FirebaseFirestore.instance;
      final CollectionReference services = firestore.collection('booked_carServicing');

      String bookingId = DateTime.now().microsecondsSinceEpoch.toString();

      // Add the date and time fields
      DateTime now = DateTime.now();
      String formattedDate = "${now.year}-${now.month}-${now.day}";
      String formattedTime = "${now.hour}:${now.minute}:${now.second}";

      // Create a map with the servicing details
      Map<String, dynamic> servicingData = {
        'username': username ?? "",
        'carType': selectedCarType,
        'carBrand': selectedCarBrand,
        'carName': widget.carName,
        'manufacturingYear': widget.selectedYear,
        'serviceType': widget.serviceType,
        'servicingOption': widget.servicingOption,
        'phone':widget.phone,
        'price':widget.price,
        'date': formattedDate, // Add the date field
        'time': formattedTime, // Add the time field
        'id': bookingId,
        // Add other data as needed
      };

      await services.doc(bookingId).set(servicingData);

    } catch (e) {
      // Handle errors and show an error dialog
    } finally {
      // Set isSavingData back to false after the operation is complete
      setState(() {
        isSavingData = false;
      });
    }
  }

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Confirmation Page'),
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 20),
                child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                      height: 100,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            // Color of the shadow
                            spreadRadius: 3,
                            // Spread radius
                            blurRadius: 4,
                            // Blur radius
                            offset: Offset(
                                0, 3), // Offset in the x, y direction
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipOval(
                              child: Image.asset(
                                "images/icons/servicing.png",
                                fit: BoxFit.fill,
                                width: 100.0,
                                height: 70.0, // Set both width and height to make it a circle
                              ),
                            ),
                          ),

                          SizedBox(width: 40),
                          Text(
                            '${widget.servicingOption}',
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),


                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          // Set the inner content color to black
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey),
                          // Border color
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              // Color of the shadow
                              spreadRadius: 3,
                              // Spread radius
                              blurRadius: 4,
                              // Blur radius
                              offset: Offset(
                                  0, 3), // Adjust the spread radius as needed
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                // Align the contents to the start (left)
                                children: [
                                  Icon(FontAwesomeIcons.locationPinLock,color: AppColors.primaryMaterialColor,),
                                  SizedBox(width: 8),
                                  // Adjust the width based on your preference
                                  Text(
                                    'Selected Service Type : ',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                          Align(
                            alignment: Alignment.topRight,
                            child:
                              Text(
                                ' ${widget.serviceType}',
                              ),),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                // Align the contents to the start (left)
                                children: [
                                  Icon(FontAwesomeIcons.solidClock, size: 18,color: AppColors.primaryMaterialColor,),
                                  SizedBox(width: 8),
                                  // Adjust the width based on your preference
                                  Text(
                                    'Booking Date and Time: ',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 10),

                              Align(
                                alignment: FractionalOffset.topRight,
                                child: Text(
                                  '${widget.pickupDateTime != null ? DateFormat('EEE, MMM d, y h:mm a').format(widget.pickupDateTime) : 'N/A'}',
                                ),
                              ),
                              SizedBox(height: 10),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                // Align the contents to the start (left)
                                children: [
                                  Icon(FontAwesomeIcons.moneyBill1Wave, size: 18,color: AppColors.primaryMaterialColor,),
                                  SizedBox(width: 8),
                                  // Adjust the width based on your preference
                                  Text(
                                    'Price : ',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),

                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  ' ${widget.price}',
                                ),
                              ),

                              SizedBox(height: 10),

                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  // Align the contents to the start (left)
                                  children: [
                                    Column(
                                        children: [
                                          Row(
                                              children: [
                                                Icon(FontAwesomeIcons.car,color: AppColors.primaryMaterialColor,),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Car Model ',
                                                  style: Theme.of(context).textTheme.caption!.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),]),
                                          Text(
                                            widget.carModel, // Display the car model from the widget property
                                            style: TextStyle(fontSize: 16), // Customize the style as needed
                                          ),
                                        ]),

                                    SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        // Align the contents to the start (left)
                                        children: [
                                          Column(
                                              children: [
                                                Row(
                                                    children: [
                                                      Icon(FontAwesomeIcons.calendarAlt, size: 18,color: AppColors.primaryMaterialColor,),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'Manufacturing Year ',
                                                        style: Theme.of(context).textTheme.caption!.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),]),
                                                Text(
                                                  widget.selectedYear != null
                                                      ? widget.selectedYear.toString()
                                                      : 'N/A',
                                                  style: TextStyle(fontSize: 16), // Customize the style as needed
                                                ),
                                              ]),]),
                                  ]),


                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                if (isSavingData)
            const CircularProgressIndicator(),
        if (!isSavingData)
    RoundButton(
        title: 'Confirm Booking',
        onPress: () async {
                            // Navigate to the ConfirmationBooking page and pass the selected data
                            await saveServicingDataToFirestore().then((_) {
                              // Data has been successfully saved
                              print('Booking data saved to Firestore.');

                              // Navigate to the success page
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => bookingSuccess()),
                              );
                            }).catchError((error) {
                              // Handle any errors that may occur during the data-saving process
                              print('Error saving booking data: $error');

                              // Show an error message in a dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: Text(
                                      'An error occurred while saving your booking: $error',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }).whenComplete(() {
                              // Set isSavingData back to false after the operation is complete
                              setState(() {
                                isSavingData = false;
                              });
                            });
                          }
                      )
]))


            )
        )  );
  }
            Widget buildDateTimeFormField({
        required String label,
        required DateTime? dateTime,
        required void Function(DateTime) onChanged,
        }) {
    TextEditingController textEditingController = TextEditingController(
    text: dateTime != null
    ? "${DateFormat('yyyy-MM-dd').format(dateTime)} at ${DateFormat.jm().format(dateTime)}"
        : 'Please select a date and time',
    );

    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    Text(label),
    TextFormField(
    controller: textEditingController,
    readOnly: true,
    decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
    borderRadius: BorderRadius.circular(10),
    ),
    errorText: dateTime == null ? 'Please select a date and time' : null,
    ),
    onTap: () async {
    DateTime? selectedDateTime = await _selectDateTime(context, dateTime);
    if (selectedDateTime != null) {
    onChanged(selectedDateTime);
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDateTime);
    String formattedTime = DateFormat.jm().format(selectedDateTime);
    setState(() {
    textEditingController.text = "$formattedDate at $formattedTime";
    });
    }
    },
    ),
    ],
    );
    }

        Future<DateTime?> _selectDateTime(BuildContext context,
        DateTime? initialDateTime) async {
      return showDatePicker(
        context: context,
        initialDate: initialDateTime ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      ).then((selectedDate) {
        if (selectedDate == null) return null;
        return showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
        ).then((selectedTime) {
          if (selectedTime == null) return null;
          return DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      });
    }
  }
