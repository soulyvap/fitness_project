// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static String get apiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';

  static FirebaseOptions web = FirebaseOptions(
    apiKey: apiKey,
    appId: '1:284329562790:web:a265eb6c9f796ebc7fda67',
    messagingSenderId: '284329562790',
    projectId: 'fitness-project-e0476',
    authDomain: 'fitness-project-e0476.firebaseapp.com',
    storageBucket: 'fitness-project-e0476.appspot.com',
    measurementId: 'G-H96K9KVP8V',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: apiKey,
    appId: '1:284329562790:android:a4f2c60a2b3d644d7fda67',
    messagingSenderId: '284329562790',
    projectId: 'fitness-project-e0476',
    storageBucket: 'fitness-project-e0476.appspot.com',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: apiKey,
    appId: '1:284329562790:ios:6ef5277dd60208ea7fda67',
    messagingSenderId: '284329562790',
    projectId: 'fitness-project-e0476',
    storageBucket: 'fitness-project-e0476.appspot.com',
    androidClientId:
        '284329562790-49uumujrt8brfketree98o0u2h84jpog.apps.googleusercontent.com',
    iosClientId:
        '284329562790-0aupsjuc2u9l79p9n8gkoh2n4h4021gi.apps.googleusercontent.com',
    iosBundleId: 'com.example.fitnessProject',
  );
}
