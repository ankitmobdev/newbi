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
        return androidGoEatECommerceApp; // Change based on flavor at runtime
      case TargetPlatform.iOS:
        return iosGoEatDriverCommerceApp; // Change based on flavor at runtime
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ---------------- ANDROID ----------------
  static const FirebaseOptions androidGoEatDriverCommerceApp = FirebaseOptions(
    apiKey: 'AIzaSyCOJDqboRSU5oaSNL4NKK0LLEWwj2UYkm0',
    appId: '1:642501298568:android:4d1937725ff4876ca5523d',
    messagingSenderId: '642501298568',
    projectId: 'goeat-dbbb7',
    storageBucket: 'goeat-dbbb7.firebasestorage.app',
  );

  static const FirebaseOptions androidGoEatECommerceApp = FirebaseOptions(
    apiKey: 'AIzaSyCOJDqboRSU5oaSNL4NKK0LLEWwj2UYkm0',
    appId: '1:642501298568:android:c4209ca1e0bf6a79a5523d',
    messagingSenderId: '642501298568',
    projectId: 'goeat-dbbb7',
    storageBucket: 'goeat-dbbb7.firebasestorage.app',
  );

  static const FirebaseOptions androidGoEatVendorApp = FirebaseOptions(
    apiKey: 'AIzaSyCOJDqboRSU5oaSNL4NKK0LLEWwj2UYkm0',
    appId: '1:642501298568:android:32c0a9b23015a764a5523d',
    messagingSenderId: '642501298568',
    projectId: 'goeat-dbbb7',
    storageBucket: 'goeat-dbbb7.firebasestorage.app',
  );

  // ---------------- iOS ----------------
  static const FirebaseOptions iosGoEatDriverCommerceApp = FirebaseOptions(
    apiKey: 'AIzaSyDUtfibuJmCgRXJEZtpnvBo28NDcnTrQXY',
    appId: '1:642501298568:ios:59cc6cebcaf5d5a3a5523d',
    messagingSenderId: '642501298568',
    projectId: 'goeat-dbbb7',
    storageBucket: 'goeat-dbbb7.firebasestorage.app',
    iosBundleId: 'com.app.portex',
  );

  // ---------------- WEB (Placeholder, update with real config) ----------------
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: '642501298568',
    projectId: 'goeat-dbbb7',
    storageBucket: 'goeat-dbbb7.firebasestorage.app',
  );
}
