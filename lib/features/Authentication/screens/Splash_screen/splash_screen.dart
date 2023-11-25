import 'dart:async';
import 'dart:math' as math;
import 'package:covid_tracker/features/Authentication/screens/Splash_screen/splash_services.dart';
import 'package:covid_tracker/resources/color.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  SplashServices splashScreen = SplashServices();
  late bool isLoading = false;
  double loadingProgress = 0.0;

  void initState() {
    super.initState();
    splashScreen.isLogin(context);
    startLoading();
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 12),
    vsync: this,
  )..repeat();

  void startLoading() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        loadingProgress += 0.03; // Adjust the speed of progress here
        if (loadingProgress >= 1.0) {
          timer.cancel();
          isLoading = true;
          // Add code to navigate to the next screen or perform the desired action here
          // Example: Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NextScreen()));
        }
      });
    });
  }

  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color to black
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: null,
      body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 200,
                width: 270,
                child: Image.asset("assets/images/logos/logo1.png"),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            // Add some space below the text
            CircularProgressIndicator(
              value: isLoading ? 1.0 : loadingProgress,
              backgroundColor: Colors.white, // Customize the background color
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryMaterialColor),
            ),
          ],
        ),

    );
  }
}