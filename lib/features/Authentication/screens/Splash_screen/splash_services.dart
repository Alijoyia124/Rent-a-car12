import 'dart:async';
import 'package:covid_tracker/features/Authentication/screens/PostScreen.dart';
import 'package:covid_tracker/features/Authentication/screens/on_boarding/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices{

  void isLogin(BuildContext context){
    final auth= FirebaseAuth.instance;
    final user=auth.currentUser;
    if(user!=null){

      Timer(const Duration(seconds: 5), () => Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen())));
    }
    else {
      Timer(const Duration(seconds: 5), () => Navigator.push(context, MaterialPageRoute(builder: (context)=>OnboardingScreen())));

    }

    }
  }