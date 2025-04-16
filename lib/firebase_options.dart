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
    apiKey: 'AIzaSyB54KV5LkA7OzXlzWfzUB_jMS3BQ0vHzE0',
    appId: '1:165679612530:web:3f56bd457c205de85cb8eb',
    messagingSenderId: '165679612530',
    projectId: 'food-project-90589',
    authDomain: 'food-project-90589.firebaseapp.com',
    storageBucket: 'food-project-90589.firebasestorage.app',
    measurementId: 'G-26XNTY3NL6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyClOHVBC4K7-tREg0mHt7CY_RcjVROXsJo',
    appId: '1:165679612530:android:97a27bf98ed395605cb8eb',
    messagingSenderId: '165679612530',
    projectId: 'food-project-90589',
    storageBucket: 'food-project-90589.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbhmc9vK54vgspVkRKdjjco5A18ghyRiw',
    appId: '1:165679612530:ios:373cc020bdb392735cb8eb',
    messagingSenderId: '165679612530',
    projectId: 'food-project-90589',
    storageBucket: 'food-project-90589.firebasestorage.app',
    iosBundleId: 'com.example.food',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBbhmc9vK54vgspVkRKdjjco5A18ghyRiw',
    appId: '1:165679612530:ios:373cc020bdb392735cb8eb',
    messagingSenderId: '165679612530',
    projectId: 'food-project-90589',
    storageBucket: 'food-project-90589.firebasestorage.app',
    iosBundleId: 'com.example.food',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB54KV5LkA7OzXlzWfzUB_jMS3BQ0vHzE0',
    appId: '1:165679612530:web:1c38d693b2f73aa45cb8eb',
    messagingSenderId: '165679612530',
    projectId: 'food-project-90589',
    authDomain: 'food-project-90589.firebaseapp.com',
    storageBucket: 'food-project-90589.firebasestorage.app',
    measurementId: 'G-R52VDCLWD6',
  );

}