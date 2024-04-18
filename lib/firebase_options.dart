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
        return windows;
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
    apiKey: 'AIzaSyA3E9Cgn4e4vDa6h1sLIs77_-AqClSSinU',
    appId: '1:737881589777:web:99e69ad10783a14019c9b0',
    messagingSenderId: '737881589777',
    projectId: 'clothingstore-3f8ea',
    authDomain: 'clothingstore-3f8ea.firebaseapp.com',
    databaseURL: 'https://clothingstore-3f8ea-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'clothingstore-3f8ea.appspot.com',
    measurementId: 'G-W1GDWBB4ZN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBcDb7Etg7tniarRsbpyK8wA5Cnr7HiX_g',
    appId: '1:737881589777:android:9395517af3724f8919c9b0',
    messagingSenderId: '737881589777',
    projectId: 'clothingstore-3f8ea',
    databaseURL: 'https://clothingstore-3f8ea-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'clothingstore-3f8ea.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDx1HS9OtxlSIfTDQQi-_N1vQ-ZVZc04hE',
    appId: '1:737881589777:ios:2c29edf75d66aa7119c9b0',
    messagingSenderId: '737881589777',
    projectId: 'clothingstore-3f8ea',
    databaseURL: 'https://clothingstore-3f8ea-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'clothingstore-3f8ea.appspot.com',
    iosBundleId: 'com.example.flutterLtdddoan',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDx1HS9OtxlSIfTDQQi-_N1vQ-ZVZc04hE',
    appId: '1:737881589777:ios:2c29edf75d66aa7119c9b0',
    messagingSenderId: '737881589777',
    projectId: 'clothingstore-3f8ea',
    databaseURL: 'https://clothingstore-3f8ea-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'clothingstore-3f8ea.appspot.com',
    iosBundleId: 'com.example.flutterLtdddoan',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA3E9Cgn4e4vDa6h1sLIs77_-AqClSSinU',
    appId: '1:737881589777:web:27c7a6be9942718a19c9b0',
    messagingSenderId: '737881589777',
    projectId: 'clothingstore-3f8ea',
    authDomain: 'clothingstore-3f8ea.firebaseapp.com',
    databaseURL: 'https://clothingstore-3f8ea-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'clothingstore-3f8ea.appspot.com',
    measurementId: 'G-WBW38X6VVW',
  );
}