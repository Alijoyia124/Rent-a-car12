import 'package:covid_tracker/features/Authentication/screens/Splash_screen/splash_screen.dart';
import 'package:covid_tracker/resources/color.dart';
import 'package:covid_tracker/resources/fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.transparent,
        // Set the primary color to transparent
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontFamily: AppFonts.sfProDisplayBold,
          ),
          backgroundColor: AppColors.primaryMaterialColor, // Set app bar background color to transparent
        ),
        scaffoldBackgroundColor: Colors.white,
        // Set scaffold background color to transparent
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 40,
            fontFamily: AppFonts.sfProDisplayBold,
            color: AppColors.primaryTextTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          headline2: TextStyle(
            fontSize: 32,
            fontFamily: AppFonts.sfProDisplayBold,
            color: AppColors.primaryTextTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          headline3: TextStyle(
            fontSize: 28,
            fontFamily: AppFonts.sfProDisplayBold,
            color: AppColors.primaryTextTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          headline4: TextStyle(
            fontSize: 24,
            fontFamily: AppFonts.sfProDisplayBold,
            color: AppColors.primaryTextTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          headline5: TextStyle(
            fontSize: 20,
            fontFamily: AppFonts.sfProDisplayBold,
            color: AppColors.primaryTextTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          headline6: TextStyle(
            fontSize: 17,
            fontFamily: AppFonts.sfProDisplayBold,
            color: AppColors.primaryTextTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          bodyText1: TextStyle(
            fontSize: 18,
            fontFamily: AppFonts.sfProDisplayBold,
            color: AppColors.primaryTextTextColor,
            height: 1.6,
          ),
          bodyText2: TextStyle(
            fontSize: 15,
            fontFamily: AppFonts.sfProDisplayBold,
            color: AppColors.primaryTextTextColor,
            height: 1.5,
          ),
          caption: TextStyle(
            fontSize: 12,
            fontFamily: AppFonts.sfProDisplayBold,
            color: AppColors.primaryTextTextColor,
            height: 1.9,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.primaryMaterialColor, // Change the button color
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: AppColors.primaryMaterialColor, // Change the elevated button color
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: AppColors.primaryMaterialColor, // Change the text button color
          ),
        ),
        iconTheme: IconThemeData(
          color: AppColors.primaryMaterialColor, // Change the icon color
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryMaterialColor, // Change the FAB color
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Your Title Here',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SplashScreen(),
      ),
    );
  }
}