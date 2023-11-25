// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../../../../../../common widgets/round_button.dart';
// import '../products.dart';
// import 'bookingPage/booking.dart';
//
// class ProductDetailPage extends StatelessWidget {
//   final Product product;
//
//   const ProductDetailPage({Key? key, required this.product}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//         body: SingleChildScrollView(
//           child: SafeArea(
//               child:Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: MediaQuery.of(context).size.height / 2,
//                       width: MediaQuery.of(context).size.width,
//                       decoration:const BoxDecoration(
//                         color: Colors.grey,
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(30),
//                           bottomRight: Radius.circular(30),
//                         ),
//                       ),
//                       child: Stack(
//                         children: [
//                           Image.asset(
//                             product.imageAsset,
//                             width: double.infinity, // Set width to fill the container
//                             height: double.infinity, // Set height to fill the container
//                             fit: BoxFit.fill, // Use BoxFit.fill to spread the image
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 15, top: 20),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Icon(Icons.arrow_back_ios_new),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 20,),
//                     Padding(padding: const EdgeInsets.all(20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                                         Text(
//               product.name,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//                             const  SizedBox(height: 20,),
//                             Row(
//                                 children: [
//                                   RatingBar.builder(
//                                     initialRating: 3.5, // The initial rating (can be any value)
//                                     minRating: 1,      // Minimum rating
//                                     direction: Axis.horizontal,
//                                     allowHalfRating: true,
//                                     itemCount: 5,      // Number of stars
//                                     itemSize: 25.0,    // Size of each star
//                                     itemBuilder: (context, _) => const Icon(
//                                       Icons.star,
//                                       color: Colors.amber,
//                                     ),
//                                     onRatingUpdate: (rating) {
//                                       // Handle the updated rating (e.g., send it to a server)
//                                       print('Rated $rating stars!');
//                                     },
//                                   ),
//                                   const  SizedBox(width: 5,),
//                                   const  Text("(450)"),
//                                 ]
//                             ) ,
//                             const  SizedBox(height: 15,),
//                             Row(
//                               children: [
//                                 Text("Rs.25000",style: Theme.of(context).textTheme.headline6!.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 ),),
//                                 const  SizedBox(width: 5,),
//                                 const   Text("Rs.30000",
//                                   style: TextStyle(
//                                     color:Colors.black,
//                                     decoration: TextDecoration.lineThrough,
//                                   ),)
//                               ],
//                             ),
//                             const   SizedBox(height: 15,),
//                       Text(
//               product.description,
//               style: Theme.of(context).textTheme.headline6!.copyWith(
//                               ),textAlign: TextAlign.justify,
//                             ),
//
//                             const SizedBox(height: 20,),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 50,right: 50),
//                               child: RoundButton(title: 'Book Now',
//                                   loading: false,
//                                   onPress: () {
//                                     Get.to(()=>const bodyBookingPage(cleaningPrice: null,),transition:Transition.fade,duration: const Duration(seconds: 1));
//                                   }
//                               ),
//                             ),
//                           ],
//                         )
//                     )
//                   ]
//               )
//           ),
//         )
//     );
//   }
// }
//
//
//
//
//
