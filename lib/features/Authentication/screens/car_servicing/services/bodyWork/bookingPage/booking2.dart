import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker/common%20widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../../common widgets/text_form_field.dart';
import '../../allBooking.dart';
import '../../detailing/cleaningSuccess.dart';

class BookingPage extends StatefulWidget {
  final String category;
  final double hatchbackPrice;
  final double sedanPrice;
  final double crossoverPrice;
  final String discount;
  final String image;
  final String serviceType;
  final String servicingOption;
  final String description;
  DateTime pickupDateTime;
  final String mainCategory;


   BookingPage({
    Key? key,
    required this.category,
    required this.hatchbackPrice,
    required this.sedanPrice,
    required this.crossoverPrice,
     required this.mainCategory,
     required this.discount,
    required this.serviceType,
    required this.servicingOption,
    required this.image,
    required this.description,
    required this.pickupDateTime,

  }) : super(key: key);


  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedServiceOption;
  DateTime? pickupDateTime = DateTime.now();
  DateTime? returnDateTime = DateTime.now();
  bool isSavingData = false;
  final auth = FirebaseAuth.instance;
  User? user;
  String? userUID;
  String? username;
  final phoneController=TextEditingController();
  final phoneFocusNode=FocusNode();
  List<int> carManufacturingYears = List.generate(25, (index) => 1999 + index);
  int? selectedYear;
  final formkey = GlobalKey<FormState>();

  void setPickupDateTime(DateTime newPickupDateTime) {
    setState(() {
      pickupDateTime = newPickupDateTime;
    });
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  String selectedCarType = 'Sedan';
  String selectedCarBrand = 'Honda'; // Selected car brand
  String selectedCarModel = 'Honda City';
  double selectedServicePrice = 0.0; // Selected car model
  TextEditingController carNameController = TextEditingController();
  final carNameFocusNode = FocusNode();

  List<String> carTypeOptions = ['Sedan', 'Hatchback', 'SUV'];
  List<String> carBrandOptions = [
    'Honda',
    'Toyota',
    'Suzuki'
  ]; // Car brand options
  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
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
  Future<void> saveBookingData() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        final userUID = user.uid;

        // Create a reference to the Firestore collection 'bodyWork'
        final bookingCollection = FirebaseFirestore.instance.collection(
            'bookings');

        // Generate a unique ID for the booking
        String bookingId = DateTime
            .now()
            .microsecondsSinceEpoch
            .toString();

        Timestamp pickupDateTimeTimestamp;
        if (selectedDate != null && selectedTime != null) {
          final DateTime combinedDateTime = DateTime(
            selectedDate!.year,
            selectedDate!.month,
            selectedDate!.day,
            selectedTime!.hour,
            selectedTime!.minute,
          );
          pickupDateTimeTimestamp = Timestamp.fromDate(combinedDateTime);
        } else {
          pickupDateTimeTimestamp = Timestamp.now();
        }
        // Create a Map to store the booking data
        Map<String, dynamic> bookingData = {
          'username': username ?? "",
          'carModel': selectedCarModel,
          'phone': phoneController.text,
          'ServiceCategory': widget.category,
          'carType': selectedCarType,
          'pickupDateTime': pickupDateTimeTimestamp,
          'price': selectedServicePrice,
          'mainCategory':widget.mainCategory,
          'id': bookingId,
        };
        // Add a new document to the 'bodyWork' collection with the same ID as the 'id' field
        await bookingCollection.doc(bookingId).set(bookingData);

        await Future.delayed(Duration(seconds: 2)); // Simulate a delay

        // After saving data, set the success state or error state
        // based on whether the operation was successful or not
        bool isSuccessful = true; // Change this based on the actual operation result

        if (isSuccessful) {
          print('Booking data saved to Firestore.');
          final List<Map<String, dynamic>> allBookings = [];
          clearTextFields();

          // Fetch all bookings and add them to the list
          final querySnapshot =
          await FirebaseFirestore.instance.collection('bodyWork').get();
          querySnapshot.docs.forEach((doc) {
            allBookings.add(doc.data() as Map<String, dynamic>);
          });

          // Navigate to the BookingListPage and pass the booking data

        } else {
          throw 'Error saving data'; // Throw an error to indicate a failure
        }
      }
    } catch (e) {
      // Handle any exceptions that may occur during the data-saving process.
      print('Error saving data: $e');
    }
  }

  Future<void> fetchServicePrice() async {
    try {
      if (selectedCarType != null && selectedServiceOption != null) {
        // Create a Firestore query to fetch the price based on the selected criteria
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('addServicingAdmin')
            .where('carType', isEqualTo: selectedCarType)
            .where('servicingOption', isEqualTo: selectedServiceOption)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Access data from the first document in the result set
          final QueryDocumentSnapshot documentSnapshot = querySnapshot.docs[0];
          final Map<String, dynamic> data = documentSnapshot.data() as Map<
              String,
              dynamic>;

          if (selectedCarType == 'Sedan' &&
              data.containsKey('sedanservicingPrice')) {
            setState(() {
              selectedServicePrice = data['sedanservicingPrice'] as double;
            });
          } else if (selectedCarType == 'Hatchback' &&
              data.containsKey('hatchbackservicingPrice')) {
            setState(() {
              selectedServicePrice = data['hatchbackservicingPrice'] as double;
            });
          } else if (selectedCarType == 'SUV' &&
              data.containsKey('crossoverservicingPrice')) {
            setState(() {
              selectedServicePrice = data['crossoverservicingPrice'] as double;
            });
          } else {
            // Handle the case where the price for the selected criteria is not available.
            print('Service price not found for the selected criteria.');
          }
        } else {
          print(
              'No documents found in the collection for the selected criteria.');
        }
      }
    } catch (e) {
      print('Error fetching service price: $e');
    }
  }
  void clearTextFields() {
    phoneController.clear();
    carNameController.clear();
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    if (selectedCarType == 'Sedan') {
      // Add the Sedan service price when the car type is Sedan
      selectedServicePrice = widget.sedanPrice;
      widgets.add(buildReadOnlyTextField(
          'Price', 'Rs. ${selectedServicePrice.toStringAsFixed(2)}'));
    } else if (selectedCarType == 'Hatchback') {
      // Add the Hatchback service price when the car type is Hatchback
      selectedServicePrice = widget.hatchbackPrice;
      widgets.add(buildReadOnlyTextField(
          'Price', 'Rs. ${selectedServicePrice.toStringAsFixed(2)}'));
    } else if (selectedCarType == 'SUV') {
      widgets.add(buildReadOnlyTextField(
          'Price', 'Rs. ${widget.crossoverPrice.toStringAsFixed(2)}'));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Booking Page'),
        ),
        body: Center( // Center widget to center the content
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 40, 17, 0),
                width: double.infinity,
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedCarType,
                        items: carTypeOptions.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCarType = value!;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Car Type'),
                      ),

                      DropdownButtonFormField<String>(
                        value: selectedCarBrand,
                        items: carBrandOptions.map((brand) {
                          return DropdownMenuItem<String>(
                            value: brand,
                            child: Text(brand),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCarBrand = value!;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Car Brand'),
                      ),
                      SizedBox(height: 20,),

                      DropdownButtonFormField<int?>(
                        value: selectedYear,
                        onChanged: (
                            int? newValue) { // Change the parameter type to int?
                          setState(() {
                            selectedYear = newValue;
                          });
                        },
                        // Rest of the code remains the same

                        items: carManufacturingYears.map((year) {
                          return DropdownMenuItem<int>(
                            value: year,
                            child: Text(year.toString()),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: "Select Car Manufacturing Year",
                        ),
                        validator: (value) {
                          if (value == null) {
                            return "Please select a year";
                          }
                          return null; // Validation passed
                        },
                      ),
                      SizedBox(height: 20,),

                      InputTextFormField(
                          myController: carNameController,
                          focusNode: carNameFocusNode,
                          decoration: InputDecoration(
                          ),
                          onFiledSubmittedValue: (value) {

                          },
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          hint: "Car Name + Variant e.x. (Toyota Corolla (xli or gli)) ",
                          onValidator: (value) {
                            return value.isEmpty ? "Enter Car Name" : null;
                          }
                      ),
                      SizedBox(height: 20,),

                      InputTextFormField(
                          myController:phoneController,
                          focusNode: phoneFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Enter Phone Number',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onFiledSubmittedValue: (value){

                          },
                          keyboardType: TextInputType.phone,
                          obscureText: false,
                          hint: "Enter your phone",
                          onValidator: (value){
                            return value.isEmpty ? "Enter Phone" : null;

                          }
                      ),
                      SizedBox(height: 50),
                      Card(
                        elevation: 10, // Controls the shadow depth
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Optional border radius
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          // Adjust the padding as needed
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            // Optional border for the container
                            borderRadius: BorderRadius.circular(
                                10), // Optional border radius
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .stretch,
                            children: [
                              buildReadOnlyTextField(
                                  'Selected Service Type',
                                  widget.category),
                              ...widgets,
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Row(crossAxisAlignment: CrossAxisAlignment
                          .center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              child: Text('Booking Date'),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                                onPressed: () => _selectTime(context),
                                child: Text("Booking Time")
                            ),
                          ]),

                      SizedBox(height: 30,),


                      const SizedBox(height: 30),
                      if (isSavingData)
                        Center(child: const CircularProgressIndicator()),
                      if (!isSavingData)
                        Builder(
                          builder: (BuildContext context) => RoundButton(
                            title: 'Buy Now',
                            onPress: () async {
                              if (formkey.currentState!.validate()) {
                                setState(() {
                                  isSavingData = true;
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => cleaningSuccessPage(
                                      carType: selectedCarType,
                                      carBrand: selectedCarBrand,
                                      carModel: selectedCarModel,
                                      selectedYear: selectedYear,
                                      carName: carNameController.text,
                                      phone:phoneController.text,
                                      serviceType: widget.serviceType,
                                      servicingOption: widget.servicingOption,
                                      price: selectedServicePrice,
                                      mainCategory:widget.mainCategory,
                                      pickupDateTime: widget.pickupDateTime, // Pass the selected date and time
                                    ),
                                  ),
                                );


                                // Call the function to save booking data
                                await saveBookingData().then((_) {
                                  // Data has been successfully saved
                                  print('Booking data saved to Firestore.');

                                  // Hide the loading indicator

                                  // Show a success message to the user or navigate to another screen.
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Booking Successful'),
                                        content: const Text(
                                          'Your booking has been successfully saved.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }).catchError((error) {
                                  // Handle any errors that may occur during the data-saving process
                                  print('Error saving booking data: $error');

                                  // Hide the loading indicator

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
                                              Navigator.of(context).pop();
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
                            },
                          ),
                        ),
                    ],
                  ),
                ) ),
            ),
        )

    );

  }


  Widget buildReadOnlyTextField(String label, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
        ),
        controller: TextEditingController(text: text),
        readOnly: true,
      ),
    );
  }

  Widget buildDateTimeFormField({
    required String label,
    required DateTime? dateTime,
    required void Function(DateTime) onChanged,
  }) {
    TextEditingController textEditingController = TextEditingController(
      text: dateTime != null
          ? "${DateFormat('yyyy-MM-dd').format(dateTime)} at ${DateFormat.jm()
          .format(dateTime)}"
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
            errorText: dateTime == null
                ? 'Please select a date and time'
                : null,
          ),
          onTap: () async {
            DateTime? selectedDateTime = await _selectDateTime(
                context, dateTime);
            if (selectedDateTime != null) {
              onChanged(selectedDateTime);
              String formattedDate = DateFormat('yyyy-MM-dd').format(
                  selectedDateTime);
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
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
      );

      if (selectedTime != null) {
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }

    return null;
  }
}