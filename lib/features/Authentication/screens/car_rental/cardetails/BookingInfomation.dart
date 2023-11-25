import 'package:covid_tracker/common%20widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'summary.dart';

class CarRentalForm extends StatefulWidget {


  final String carName;
  final String carModel;
  final String carManufacturer;
  final String image;
  final String description;
  final double rentPerDay;
  final DateTime pickupDateTime;
  final DateTime returnDateTime;

  const CarRentalForm({
    required this.carName,
    required this.carModel,
    required this.carManufacturer,
    required this.image,
    required this.description,
    required this.rentPerDay,
    required this.pickupDateTime,
    required this.returnDateTime,



  });

  @override
  State<CarRentalForm> createState() => _CarRentalFormState();
}

class _CarRentalFormState extends State<CarRentalForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? pickupDateTime = DateTime.now();
  final usernameController = TextEditingController();

  DateTime? returnDateTime = DateTime.now();
  bool withDriver = false;
  String? pickupDateAndTimeError;
  List<String> shopNames = [
    'Seven Star Rent a Car(Naya Pull , Main road Tajpura, Lahore, Punjab)',
    'Seven Star Rent a Car(Barkat Market, Garden Town, Lahore, Punjab)',
    '153H, Sector H Dha Phase 1, Lahore, Punjab'];
  String selectedShop = '';  // Initialize with the first shop name
  TextEditingController pickUpLocationController = TextEditingController();
  TextEditingController returnLocationController = TextEditingController();

  void initState() {
    super.initState();
    selectedShop = shopNames.isNotEmpty ? shopNames[0] : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Car Rental Form"),
        ),
        body: SingleChildScrollView(
          child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 70,
                        right: 20,
                        left: 20,
                        bottom: 0,
                        child:  Image.network(
                          widget.image, // Use the imageUrl property from the Car object
                          width: 300.0,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 18, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin:
                                    EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 12),
                                    padding:
                                    EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 7,
                                            spreadRadius: 0.5)
                                      ],
                                    ),
                                    child: Image.asset(
                                      "assets/images/logos/ic_tesla_black.png",
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('With Driver:',style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15),),
                            Switch(
                              value: withDriver,
                              onChanged: (value) {
                                setState(() {
                                  withDriver = value;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 15),

                        // Pick Up Location
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Pick Up Location',style: Theme.of(context).textTheme.caption!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                            ),),
                        SizedBox(height: 15,),

                            DropdownButtonFormField<String>(
                              value: selectedShop,
                              items: shopNames.map((String shopName) {
                                return DropdownMenuItem<String>(
                                  value: shopName,
                                  child: Text(shopName),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedShop = newValue!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Select Pick up Shop',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a shop';
                                }
                                return null;
                              },
                              isExpanded: true, // Set isExpanded to true
                            ),

]),
                        SizedBox(height: 15),
                        // Return Location
                        buildDateTimeFormField(
                          label: 'Pick Up Date and Time',
                          dateTime: pickupDateTime,
                          onChanged: (selectedDateTime) {
                            setState(() {
                              pickupDateTime = selectedDateTime;
                              pickupDateAndTimeError = null;
                            });
                          },
                        ),
                        SizedBox(height: 15),

                        // Return Date and Time
                        buildDateTimeFormField(
                          label: 'Return Date and Time',

                          dateTime: returnDateTime,
                          onChanged: (selectedDateTime) {
                            setState(() {
                              returnDateTime = selectedDateTime;
                            });
                          },                        ),

                        SizedBox(height: 30),

                        RoundButton(
                          title: 'Book Now',
                          onPress: () {
                            if (pickupDateTime == null || returnDateTime == null) {
                              // Handle error if date and time are not selected
                              // You can show an error message or prevent navigation
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => bookingSummary(
                                  carName: widget.carName,
                                  carModel: widget.carModel,
                                  carManufacturer: widget.carManufacturer,
                                  image: widget.image,
                                  description: widget.description,
                                  rentPerDay: widget.rentPerDay,
                                  pickupDateTime: pickupDateTime!, // Pass the selected pickup date and time
                                  returnDateTime: returnDateTime!, // Pass the selected return date and time
                                  selectedShop: selectedShop,

                                  // Pass the selected shop here
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ));
  }

  // A custom widget for date and time input
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
