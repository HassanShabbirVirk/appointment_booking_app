import 'package:appointment_booking_1/providers/date_provider.dart';
import 'package:appointment_booking_1/providers/hide_password_provider.dart';
import 'package:appointment_booking_1/providers/loading_provider.dart';
import 'package:appointment_booking_1/providers/theme_change_provider.dart';
import 'package:appointment_booking_1/routes/app_navigation.dart';
import 'package:appointment_booking_1/routes/app_navigation_routes.dart';
import 'package:appointment_booking_1/routes/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HidePasswordProvider()),
          ChangeNotifierProvider(create: (_) => LoadingProvider()),
          ChangeNotifierProvider(create: (_) => DateProvider()),
          ChangeNotifierProvider(create: (_) => ThemeChanger())
        ],
        child: Builder(builder: (BuildContext context) {
          final themeChanger = Provider.of<ThemeChanger>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            themeMode: themeChanger.themeMode,
            theme: ThemeData(
              // primarySwatch: Colors.green,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                background: Colors.white,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                background: Colors.black,
                brightness: Brightness.dark,
              ),
              // primarySwatch: Colors.green,
            ),
            // home: const SplashScreen(),
            navigatorKey: AppNavigation.navigationKey,
            initialRoute: AppNavRoutes.initialRoute,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        }));
  }
}
