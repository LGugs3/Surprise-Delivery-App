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
    apiKey: 'AIzaSyBZ7z2PHZbe8EZR3dbVZWzFTyj5iBezqqU',
    appId: '1:126860737484:web:2ca49928fede2a272abb69',
    messagingSenderId: '126860737484',
    projectId: 'upick-e6d58',
    authDomain: 'upick-e6d58.firebaseapp.com',
    storageBucket: 'upick-e6d58.firebasestorage.app',
    measurementId: 'G-GC489V15XT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8QqKeamXTn4MovrZpo9cvJ-Sd4WmxIms',
    appId: '1:126860737484:android:52d5006d7ee3f4202abb69',
    messagingSenderId: '126860737484',
    projectId: 'upick-e6d58',
    storageBucket: 'upick-e6d58.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD_saeJPau2e7oAzy7ELS2ylzHQiHUh1Nw',
    appId: '1:126860737484:ios:c77f6d9da4b8a1682abb69',
    messagingSenderId: '126860737484',
    projectId: 'upick-e6d58',
    storageBucket: 'upick-e6d58.firebasestorage.app',
    iosBundleId: 'champlain.edu.surpirseDeliveryApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD_saeJPau2e7oAzy7ELS2ylzHQiHUh1Nw',
    appId: '1:126860737484:ios:c77f6d9da4b8a1682abb69',
    messagingSenderId: '126860737484',
    projectId: 'upick-e6d58',
    storageBucket: 'upick-e6d58.firebasestorage.app',
    iosBundleId: 'champlain.edu.surpirseDeliveryApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBZ7z2PHZbe8EZR3dbVZWzFTyj5iBezqqU',
    appId: '1:126860737484:web:41cfb80d7cd34b552abb69',
    messagingSenderId: '126860737484',
    projectId: 'upick-e6d58',
    authDomain: 'upick-e6d58.firebaseapp.com',
    storageBucket: 'upick-e6d58.firebasestorage.app',
    measurementId: 'G-J2D7KK0BX0',
  );
}
