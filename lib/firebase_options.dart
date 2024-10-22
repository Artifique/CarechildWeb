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
    apiKey: 'AIzaSyALlS_OOfcMqvRsWDZzMd8BXSQbxNS7RGw',
    appId: '1:294435790256:web:cf8ae02849778ae940ca75',
    messagingSenderId: '294435790256',
    projectId: 'access-ability-9faa7',
    authDomain: 'access-ability-9faa7.firebaseapp.com',
    storageBucket: 'access-ability-9faa7.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9o_HOCMuSbgMh6Dcll0hGfBIqc96tX7k',
    appId: '1:294435790256:android:c6a74049a746909440ca75',
    messagingSenderId: '294435790256',
    projectId: 'access-ability-9faa7',
    storageBucket: 'access-ability-9faa7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCyGDkmn2BsLJ-w7x3z3H1C9y8pjJLBC8w',
    appId: '1:294435790256:ios:a393dc3c40c9220b40ca75',
    messagingSenderId: '294435790256',
    projectId: 'access-ability-9faa7',
    storageBucket: 'access-ability-9faa7.appspot.com',
    iosBundleId: 'com.example.accessability',
  );
}