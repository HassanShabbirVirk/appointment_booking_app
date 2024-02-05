import 'package:appointment_booking_1/Model/user_email_model.dart';
import 'package:appointment_booking_1/routes/app_navigation_routes.dart';
import 'package:appointment_booking_1/ui/PatientScreens/patient_dashboard.dart';
import 'package:appointment_booking_1/ui/admin/admin_Home.dart';
import 'package:appointment_booking_1/ui/auth/login_screen.dart';
import 'package:appointment_booking_1/ui/auth/signup_screen.dart';
import 'package:appointment_booking_1/ui/splash_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppNavRoutes.initialRoute:
        return routeScreen(child: const SplashScreen());
      case AppNavRoutes.signUpScreen:
        return routeScreen(child: const SignUpScreen());
      case AppNavRoutes.loginScreen:
        return routeScreen(child: const LoginScreen());
      case AppNavRoutes.patientDashboard:
        UserEmailModel userEmail = args as UserEmailModel;
        return routeScreen(
            child: PatientDashboard(
          userId: userEmail.email,
        ));
      case AppNavRoutes.adminHome:
        return routeScreen(child: const AdminHome());

      // case AppNavRoutes.initialRoute:
      //   return routeScreen(child: const HomeScreen());

      // case AppNavRoutes.casesComplaintsDetails:
      //   CasesComplaintsModel casesComplaintsModel =
      //       args as CasesComplaintsModel;
      //   return routeScreen(
      //     child: CaseComplaintDetailsScreen(
      //       currentCaseComplaint: casesComplaintsModel,
      //     ),
      //   );

      //DEFAULT CASE
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Text('asd');
    });
  }

  static Route<dynamic> routeScreen(
      {Widget? child, bool fullscreenDialog = false}) {
    return MaterialPageRoute(
      builder: (context) => SafeArea(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: child!,
        ),
      ),
    );
  }
}
