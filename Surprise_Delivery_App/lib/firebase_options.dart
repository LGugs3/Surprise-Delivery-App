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

  static FirebaseOptions web = FirebaseOptions(
    apiKey: "${dotenv.env['WEB_API']}",
    appId: '1:126860737484:web:2ca49928fede2a272abb69',
    messagingSenderId: '126860737484',
    projectId: 'upick-e6d58',
    authDomain: 'upick-e6d58.firebaseapp.com',
    storageBucket: 'upick-e6d58.firebasestorage.app',
    measurementId: 'G-GC489V15XT',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: "${dotenv.env['ANDROID_API']}",
    appId: '1:126860737484:android:52d5006d7ee3f4202abb69',
    messagingSenderId: '126860737484',
    projectId: 'upick-e6d58',
    storageBucket: 'upick-e6d58.firebasestorage.app',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: "${dotenv.env['IOS_API']}",
    appId: '1:126860737484:ios:c77f6d9da4b8a1682abb69',
    messagingSenderId: '126860737484',
    projectId: 'upick-e6d58',
    storageBucket: 'upick-e6d58.firebasestorage.app',
    iosBundleId: 'champlain.edu.surpirseDeliveryApp',
  );

  static FirebaseOptions macos = FirebaseOptions(
    apiKey: "${dotenv.env['MAC_API']}",
    appId: '1:126860737484:ios:c77f6d9da4b8a1682abb69',
    messagingSenderId: '126860737484',
    projectId: 'upick-e6d58',
    storageBucket: 'upick-e6d58.firebasestorage.app',
    iosBundleId: 'champlain.edu.surpirseDeliveryApp',
  );

  static FirebaseOptions windows = FirebaseOptions(
    apiKey: "${dotenv.env['WINDOWS_API']}",
    appId: '1:126860737484:web:41cfb80d7cd34b552abb69',
    messagingSenderId: '126860737484',
    projectId: 'upick-e6d58',
    authDomain: 'upick-e6d58.firebaseapp.com',
    storageBucket: 'upick-e6d58.firebasestorage.app',
    measurementId: 'G-J2D7KK0BX0',
  );
}
