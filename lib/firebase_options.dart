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
    apiKey: 'AIzaSyD0Ltw7EM3dH9s9dzvsgi4kuRiBsxP-FPc',
    appId: '1:964801260122:web:74646afc01276e3c8ac663',
    messagingSenderId: '964801260122',
    projectId: 'bitirme-8a234',
    authDomain: 'bitirme-8a234.firebaseapp.com',
    storageBucket: 'bitirme-8a234.firebasestorage.app',
    measurementId: 'G-N2QCJGFPNG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwY_GdEV36smrdLRToVyQq7FXxmG4Ezqw',
    appId: '1:964801260122:android:edcbd4fdcc6499308ac663',
    messagingSenderId: '964801260122',
    projectId: 'bitirme-8a234',
    storageBucket: 'bitirme-8a234.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBfXKdBvXHDRdsAYmyTOn59TvWIOZAtxc0',
    appId: '1:964801260122:ios:4b6dcaed8dea0dcc8ac663',
    messagingSenderId: '964801260122',
    projectId: 'bitirme-8a234',
    storageBucket: 'bitirme-8a234.firebasestorage.app',
    iosBundleId: 'com.example.bitirme',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBfXKdBvXHDRdsAYmyTOn59TvWIOZAtxc0',
    appId: '1:964801260122:ios:4b6dcaed8dea0dcc8ac663',
    messagingSenderId: '964801260122',
    projectId: 'bitirme-8a234',
    storageBucket: 'bitirme-8a234.firebasestorage.app',
    iosBundleId: 'com.example.bitirme',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD0Ltw7EM3dH9s9dzvsgi4kuRiBsxP-FPc',
    appId: '1:964801260122:web:ae1b046b727e38a68ac663',
    messagingSenderId: '964801260122',
    projectId: 'bitirme-8a234',
    authDomain: 'bitirme-8a234.firebaseapp.com',
    storageBucket: 'bitirme-8a234.firebasestorage.app',
    measurementId: 'G-1N8YVR2G1L',
  );
}
