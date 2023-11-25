// import 'package:flutter/material.dart';
// class TopMenuAndShowcase extends StatelessWidget {
//   const TopMenuAndShowcase({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//         appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.grey,
//     ),
//
//     body: SingleChildScrollView(
//     child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     Container(
//     width: double.infinity,
//     height: 350,
//     decoration: BoxDecoration(
//     color: Colors.grey,
//     borderRadius: BorderRadius.only(
//     bottomRight: Radius.circular(50),
//     bottomLeft: Radius.circular(50),
//     ),
//     ),
//     child: Stack(
//     children: [
//     Positioned(
//     top: 70,
//     right: 20,
//     left: 20,
//     bottom: 0,
//     child: Image.asset(
//     "assets/images/tesla_1.png",
//     width: 300,
//     ),
//     ),
//     Positioned(
//     top: 0,
//     right: 0,
//     left: 0,
//     child: Column(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//     Container(
//     margin: EdgeInsets.fromLTRB(15, 0, 18, 0),
//     child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//     Container(
//     margin:
//     EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//     padding:
//     EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//     decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(10),
//     color: Colors.white,
//     boxShadow: [
//     BoxShadow(
//     color: Colors.black12,
//     blurRadius: 7,
//     spreadRadius: 0.5)
//     ],
//     ),
//     child: Image.asset(
//     "assets/images/logos/ic_tesla_black.png",
//     width: 25,
//     height: 25,
//     ),
//     ),
//
//
//     ],
//     ),
//     ),
//     ],
//     ),
//     ),
//     ],
//     ),
//     )
//
//     ]))));
//   }
// }
