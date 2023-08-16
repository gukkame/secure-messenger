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
    apiKey: 'AIzaSyDbeK2aPX8Li6gN0Ac8vM3mhsDrA9qHDm4',
    appId: '1:644433878577:web:e670dc7d4e100f3f41ff10',
    messagingSenderId: '644433878577',
    projectId: 'messenger-56263',
    authDomain: 'messenger-56263.firebaseapp.com',
    storageBucket: 'messenger-56263.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDCpajTWx7EmXVktR4ikvLW6tvKiuc17t0',
    appId: '1:644433878577:android:08c6b410d6c7e3ca41ff10',
    messagingSenderId: '644433878577',
    projectId: 'messenger-56263',
    storageBucket: 'messenger-56263.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2jzKKJwTRlReFK8j7kOetRIQb6ttUZ7o',
    appId: '1:644433878577:ios:5faa8c63030b61db41ff10',
    messagingSenderId: '644433878577',
    projectId: 'messenger-56263',
    storageBucket: 'messenger-56263.appspot.com',
    iosClientId: '644433878577-kosd5llcvgovcgg8cn4o8ujfffe0kpt3.apps.googleusercontent.com',
    iosBundleId: 'com.example.secureMessenger',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB2jzKKJwTRlReFK8j7kOetRIQb6ttUZ7o',
    appId: '1:644433878577:ios:5d96fec09e7cf3d341ff10',
    messagingSenderId: '644433878577',
    projectId: 'messenger-56263',
    storageBucket: 'messenger-56263.appspot.com',
    iosClientId: '644433878577-t325fdm51d21k2vnte9f1k2jpn3m3ejg.apps.googleusercontent.com',
    iosBundleId: 'com.example.secureMessenger.RunnerTests',
  );
}
