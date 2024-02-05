import 'package:appointment_booking_1/routes/app_navigation.dart';
import 'package:appointment_booking_1/routes/app_navigation_routes.dart';
import 'package:appointment_booking_1/utils/app_colors.dart';
import 'package:appointment_booking_1/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogOut extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  LogOut({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        auth.signOut().then((value) {
          AppNavigation.navigateTo(routeName: AppNavRoutes.loginScreen);
        }).onError((error, stackTrace) {
          Utils().toastMessage(error.toString());
        });
      },
      icon: const Icon(
        Icons.logout,
        color: AppColors.whiteTextColor,
      ),
    );
  }
}
