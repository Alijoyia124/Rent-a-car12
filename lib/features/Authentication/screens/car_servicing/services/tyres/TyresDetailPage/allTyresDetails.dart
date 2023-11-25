import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker/features/Authentication/screens/car_servicing/services/servicebookingSummary.dart';
import 'package:flutter/material.dart';
import 'package:covid_tracker/common%20widgets/round_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../tyres_categories.dart';

class allTyresDetails extends StatefulWidget {
  final String category;
  final String tyreSize;
  final double tyrePrice;
  final String discount;
  final String description;
  allTyresDetails({
    required this.category,
    required this.tyreSize,
    required this.tyrePrice,
    required this.discount,
  required this.description,
  });
  @override
  State<allTyresDetails> createState() => _allTyresDetailsState();
}

class _allTyresDetailsState extends State<allTyresDetails> {

  List<Map<String, dynamic>> tyreData = [];

  // Function to fetch data from Firestore
  Future<void> fetchTyreData() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('addTyreAdmin').get();

    final List<DocumentSnapshot> documents = querySnapshot.docs;

    for (DocumentSnapshot document in documents) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      tyreData.add(data);
    }
    // This will trigger a rebuild with the fetched data.
    setState(() {});
  }

  @override
  void initState() {
    fetchTyreData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height /2,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            )
                        ),

                        child:Stack(
                          children: [
                            Center(child:tyresCategories(),),
                            Padding(padding: EdgeInsets.only(left: 15,top: 20),
                              child: InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.arrow_back_ios_new,color: Colors.white),
                              )
                              ,
                            )
                          ],
                        )
                    ),
                    SizedBox(height: 20,),
                    Padding(padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
    StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('addTyreAdmin').where('category', isEqualTo: widget.category).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) {
    return Center(child: Text('Error: ${snapshot.error}'));
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    return Center(child: Text('No data available.'));
    }

    // Use the data in your widget
    return Column(
    children: snapshot.data!.docs.map((DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
    Text("${(widget.category) ?? "Default Category"}",
      style: Theme.of(context).textTheme.headline5!.copyWith(
      fontWeight: FontWeight.bold,
      )),

              Text("Rs.${(widget.tyrePrice) ?? "Default Price"}",style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.bold,
              ),),
              // SizedBox(width: 5,),
              // Text("Rs.30000",
              //   style: TextStyle(
              //     color:Colors.black,
              //     decoration: TextDecoration.lineThrough,
              //   ),),
]),
                Row(
                children: [
                  Text("Size: ${(widget.tyreSize) ?? "Default Category"}"),

                ]
                ),
    Row(
        children: [
          RatingBar.builder(
            initialRating: 3.5, // The initial rating (can be any value)
            minRating: 1,      // Minimum rating
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,      // Number of stars
            itemSize: 25.0,    // Size of each star
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              // Handle the updated rating (e.g., send it to a server)
              print('Rated $rating stars!');
            },
          ),
          SizedBox(width: 5,),
          Text("(12)"),
        ]
    ) ,
      SizedBox(height: 15,),

      SizedBox(height: 15,),
          Text("Description",style: Theme.of(context).textTheme.headline6!.copyWith(
      fontWeight: FontWeight.bold
      )),
          Text("${widget.description ?? "Default description"}", style: Theme.of(context).textTheme.headline6!.copyWith(),
            textAlign: TextAlign.justify,
          ),


          SizedBox(height: 20,),
      Padding(
      padding: const EdgeInsets.only(left: 50,right: 50),
      child: RoundButton(title: 'Buy Now',
      loading: false,
      onPress: () {
      Get.to(()=>BookingSummaryPage(tyreSize: widget.tyreSize, tyrePrice: widget.tyrePrice, category: widget.category, discount: widget.discount,),transition:Transition.fade,duration: Duration(seconds: 1));
      }
      ),
      )
        ]);
    }).toList()
    );
    })
    // Text("",
    //

   ])
    )
   ]
    )
  )
                    )
    );

  }}

