// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAQ35mPKD8SLtakXB2UMeFknrtHmoTOAdY',
    appId: '1:1069090358714:web:a402145f31d3f8a9bf0983',
    messagingSenderId: '1069090358714',
    projectId: 'ilo2025',
    authDomain: 'ilo2025.firebaseapp.com',
    storageBucket: 'ilo2025.firebasestorage.app',
    measurementId: 'G-4MK1D81XSG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBt8IIyCJtTFo5UnAdGHx9sycutpFlnAuk',
    appId: '1:233394389923:android:84e27aa51e91e6f55c5016',
    messagingSenderId: '233394389923',
    projectId: 'ilo-event2025',
    storageBucket: 'ilo-event2025.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDM1c-qjI6bFrjM8J-UYgCTBafStEs54V8',
    appId: '1:1069090358714:ios:a32ad088c447671ebf0983',
    messagingSenderId: '1069090358714',
    projectId: 'ilo2025',
    storageBucket: 'ilo2025.firebasestorage.app',
    iosClientId: '1069090358714-avo0vu0susu522rm4l2vaquhfelj5ql7.apps.googleusercontent.com',
    iosBundleId: 'com.example.eventProkit',
  );
}