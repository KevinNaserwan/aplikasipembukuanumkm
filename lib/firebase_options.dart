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
    apiKey: 'AIzaSyCcscqONMxHRQneKTSKdXa88rEVIV-fSWg',
    appId: '1:802355880430:web:8db0162f9c7f1a14022eff',
    messagingSenderId: '802355880430',
    projectId: 'umkm-3a9bd',
    authDomain: 'umkm-3a9bd.firebaseapp.com',
    storageBucket: 'umkm-3a9bd.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjuiWLIIe87w_hPBSh5v5jwM3l3XaItNs',
    appId: '1:802355880430:android:dbb14b6bb26eb021022eff',
    messagingSenderId: '802355880430',
    projectId: 'umkm-3a9bd',
    storageBucket: 'umkm-3a9bd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBniR81qVd0nH4yvQ2UrzIlAP8Zjou8xec',
    appId: '1:802355880430:ios:b1aaaf441e94ff8d022eff',
    messagingSenderId: '802355880430',
    projectId: 'umkm-3a9bd',
    storageBucket: 'umkm-3a9bd.appspot.com',
    iosBundleId: 'com.example.aplikasipembukuanumkm',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBniR81qVd0nH4yvQ2UrzIlAP8Zjou8xec',
    appId: '1:802355880430:ios:4ba5a807f59c6b0a022eff',
    messagingSenderId: '802355880430',
    projectId: 'umkm-3a9bd',
    storageBucket: 'umkm-3a9bd.appspot.com',
    iosBundleId: 'com.example.aplikasipembukuanumkm.RunnerTests',
  );
}
