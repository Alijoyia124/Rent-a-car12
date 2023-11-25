import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:covid_tracker/common%20widgets/Category.dart';
import 'package:covid_tracker/common%20widgets/hero_carousel.dart';
import 'package:covid_tracker/common%20widgets/sidebar_menu/sidebar.dart';
import 'package:covid_tracker/common%20widgets/listTile.dart';
import 'package:covid_tracker/common%20widgets/_buildCircleAvatar.dart';
import 'package:get/get.dart';
import 'car_servicing/services/bodyWork/bodyWork.dart';
import 'car_servicing/services/cleaning/cleaning.dart';
import 'car_servicing/services/detailing/detailingCar.dart';
import 'car_servicing/services/serviceCenters/allServiceCenters.dart';
import 'car_servicing/services/servicing/servicing.dart';
import 'car_servicing/services/tyres/tyreProducts.dart';

class CarService extends StatelessWidget {
  const CarService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Car Servicing",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const sideBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 1.6,
                  viewportFraction: 0.9,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  initialPage: 2,
                  autoPlay: true,
                ),
                items: Category.categories
                    .map((category) => Carousel(category: category))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Services",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Wrap each GestureDetector with Flexible to make them responsive
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const bodyWork(),
                          transition: Transition.fade,
                          duration: const Duration(seconds: 1));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatarWidget(
                        text: "Body Work",
                        imagePath: "images/icons/body.png",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const TyreProducts(),
                          transition: Transition.fade,
                          duration: const Duration(seconds: 1));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatarWidget(
                        text: "Tyres",
                        imagePath: "images/icons/tyre.png",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const cleaningWork(),
                          transition: Transition.fade,
                          duration: const Duration(seconds: 1));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatarWidget(
                        text: "Cleaning",
                        imagePath: "images/icons/cleaning.png",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const servicingWork(),
                          transition: Transition.fade,
                          duration: const Duration(seconds: 1));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatarWidget(
                        text: "Servicing",
                        imagePath: "images/icons/servicing.png",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const detailingWork(),
                          transition: Transition.fade,
                          duration: const Duration(seconds: 1));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatarWidget(
                        text: "Detailing",
                        imagePath: "images/icons/body.png",
                      ),
                    ),
                  ),
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular Service Centers",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceCenters(),
                        ),
                      );
                    },
                    child: Text(
                      "See All",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Place the ListView directly inside the SingleChildScrollView
            Container(
              padding: const EdgeInsets.only(left: 12),
              height: 300,
              child: const listTile(),
            ),
          ],
        ),
      ),
    );
  }
}