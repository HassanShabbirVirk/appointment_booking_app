import 'package:appointment_booking_1/routes/app_navigation_routes.dart';
import 'package:appointment_booking_1/routes/screen_arguments.dart';
import 'package:flutter/material.dart';

class AppNavigation {
  static final GlobalKey<NavigatorState> navigationKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo({String? routeName, Object? arguments}) =>
      navigationKey.currentState!.pushNamed(
        routeName!,
        arguments: arguments ?? const ScreenArguments(),
      );

  static Future<dynamic> pushReplacementTo(fingerprintRegistrationRoute,
          {String? routeName, Object? arguments}) =>
      navigationKey.currentState!
          .pushReplacementNamed(routeName!, arguments: arguments);

  static Future<dynamic> popAndPush({String? routeName, Object? arguments}) =>
      navigationKey.currentState!
          .popAndPushNamed(routeName!, arguments: arguments);

  static Future<dynamic> pushAndKillAll(
      {String? routeName, RoutePredicate? predicate, Object? arguments}) {
    return navigationKey.currentState!.pushNamedAndRemoveUntil(
      routeName!,
      predicate ??
          ModalRoute.withName(
            AppNavRoutes.initialRoute,
          ),
      arguments: arguments,
    );
  }

  static void popUntil({required String routeName}) =>
      navigationKey.currentState!.popUntil(ModalRoute.withName(routeName));

  static void goBack() => navigationKey.currentState!.pop();

  static bool canPop(BuildContext context) =>
      navigationKey.currentState!.canPop();

  static BuildContext get currentContext => navigationKey.currentState!.context;

  static void removeAllRoutes() =>
      navigationKey.currentState!.popUntil((route) => route.isFirst);
}
