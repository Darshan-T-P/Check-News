// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyDm9NK2GOO-Wg-UOntfnzi1sdWCvSFOpD4',
    appId: '1:187193820699:web:f33a0445ae7e5edc989abe',
    messagingSenderId: '187193820699',
    projectId: 'uthukuli-news-c7476',
    authDomain: 'uthukuli-news-c7476.firebaseapp.com',
    storageBucket: 'uthukuli-news-c7476.firebasestorage.app',
    measurementId: 'G-XKT8ZT8JZN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDT3pgN5g2AN5zmqLaUDObMpLHB_XxIbV4',
    appId: '1:187193820699:android:6821e4dbf6ca9873989abe',
    messagingSenderId: '187193820699',
    projectId: 'uthukuli-news-c7476',
    storageBucket: 'uthukuli-news-c7476.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAkc-Rp1aKBRVuuJUM-QxG9S83imSdM_3A',
    appId: '1:187193820699:ios:1e7e2f9c3a4e3faa989abe',
    messagingSenderId: '187193820699',
    projectId: 'uthukuli-news-c7476',
    storageBucket: 'uthukuli-news-c7476.firebasestorage.app',
    iosBundleId: 'com.example.checkNews',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAkc-Rp1aKBRVuuJUM-QxG9S83imSdM_3A',
    appId: '1:187193820699:ios:1e7e2f9c3a4e3faa989abe',
    messagingSenderId: '187193820699',
    projectId: 'uthukuli-news-c7476',
    storageBucket: 'uthukuli-news-c7476.firebasestorage.app',
    iosBundleId: 'com.example.checkNews',
  );
}
