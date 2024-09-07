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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC7fi42wIbuc6wFLzUHlOVYCxDAlIF8mjA',
    appId: '1:659116665623:android:24b20d1c1bca760235e552',
    messagingSenderId: '659116665623',
    projectId: 'chat-568d3',
    storageBucket: 'chat-568d3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDKglfm6JgyXEs8KafAF4iN0b4fcJz5eTA',
    appId: '1:659116665623:ios:cc152c028e8b16ac35e552',
    messagingSenderId: '659116665623',
    projectId: 'chat-568d3',
    storageBucket: 'chat-568d3.appspot.com',
    androidClientId: '659116665623-v4ku9iglv22n9jmpe08tqjtl042pgds0.apps.googleusercontent.com',
    iosClientId: '659116665623-legml9cri4nhrqh7ees3iuu59o2qjktu.apps.googleusercontent.com',
    iosBundleId: 'com.example.chat',
  );
}
