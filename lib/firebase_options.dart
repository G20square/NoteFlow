// This is a stub file that will be replaced by `flutterfire configure`.
// It allows the app to compile before Firebase is set up.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ⚠️  Replace these with real values by running: flutterfire configure
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA5QRv4cZUKoezE39zomX_2sqBDhRdg9zM',
    appId: '1:754356371434:web:f886f44d937007b7cd3c93', // Extrapolated from Android/Project ID
    messagingSenderId: '754356371434',
    projectId: 'noteflow-prod-d81ff',
    authDomain: 'noteflow-prod-d81ff.firebaseapp.com',
    storageBucket: 'noteflow-prod-d81ff.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5QRv4cZUKoezE39zomX_2sqBDhRdg9zM',
    appId: '1:754356371434:android:8c85fcafddcd8f49cd3c93',
    messagingSenderId: '754356371434',
    projectId: 'noteflow-prod-d81ff',
    storageBucket: 'noteflow-prod-d81ff.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5QRv4cZUKoezE39zomX_2sqBDhRdg9zM',
    appId: '1:754356371434:ios:6f86f44d937007b7cd3c93', // Extrapolated
    messagingSenderId: '754356371434',
    projectId: 'noteflow-prod-d81ff',
    storageBucket: 'noteflow-prod-d81ff.firebasestorage.app',
    iosBundleId: 'com.gautham.noteflow',
  );
}
