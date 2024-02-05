// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAOON1GL8-wLvNMotczrLpTsrH-1RbKjYk',
    appId: '1:22404686388:web:c478aaa7ccfc9cf8d1a061',
    messagingSenderId: '22404686388',
    projectId: 'appointment-booking-1',
    authDomain: 'appointment-booking-1.firebaseapp.com',
    storageBucket: 'appointment-booking-1.appspot.com',
    measurementId: 'G-VH37YNSS33',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyApET3OXxoYAUZ0UKwPPepzp6K_Dj6vY34',
    appId: '1:22404686388:android:c7399c26e8e06699d1a061',
    messagingSenderId: '22404686388',
    projectId: 'appointment-booking-1',
    storageBucket: 'appointment-booking-1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBI9A1h3ztfEZVgYerH7ZOsaGW6VtMqFCg',
    appId: '1:22404686388:ios:edeb7c96b893df5bd1a061',
    messagingSenderId: '22404686388',
    projectId: 'appointment-booking-1',
    storageBucket: 'appointment-booking-1.appspot.com',
    iosBundleId: 'com.example.appointmentBooking1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBI9A1h3ztfEZVgYerH7ZOsaGW6VtMqFCg',
    appId: '1:22404686388:ios:5cb11a77981d581bd1a061',
    messagingSenderId: '22404686388',
    projectId: 'appointment-booking-1',
    storageBucket: 'appointment-booking-1.appspot.com',
    iosBundleId: 'com.example.appointmentBooking1.RunnerTests',
  );
}