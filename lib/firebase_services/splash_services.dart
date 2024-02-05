import 'dart:async';

import 'package:appointment_booking_1/Model/user_email_model.dart';
import 'package:appointment_booking_1/routes/app_navigation.dart';
import 'package:appointment_booking_1/routes/app_navigation_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
      if (user.email == 'administrator@gmail.com') {
        // Timer(
        //     const Duration(seconds: 3),
        //     () => Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => const AdminHome())));
        Timer(const Duration(seconds: 3),
            () => AppNavigation.navigateTo(routeName: AppNavRoutes.adminHome));
      } else {
        // Timer(
        //     const Duration(seconds: 3),
        //     () => Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => const LoginScreen())));
        Timer(
            const Duration(seconds: 3),
            () => AppNavigation.navigateTo(
                routeName: AppNavRoutes.patientDashboard,
                arguments: UserEmailModel(email: user.email)));
      }
    } else {
      // Timer(
      //     const Duration(seconds: 3),
      //     () => Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => const LoginScreen())));
      Timer(const Duration(seconds: 3),
          () => AppNavigation.navigateTo(routeName: AppNavRoutes.loginScreen));
    }
  }
}
