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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBxHX8B15KZWl4AD-72S_b0OPjzIKzojd4",
    projectId: "bhuprahari06",
    messagingSenderId: "275036991203",
    appId: "1:275036991203:android:3c1ea18c22b51d95921fd6",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBxHX8B15KZWl4AD-72S_b0OPjzIKzojd4",
    projectId: "bhuprahari06",
    messagingSenderId: "275036991203",
    appId: "1:275036991203:android:3c1ea18c22b51d95921fd6",
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBxHX8B15KZWl4AD-72S_b0OPjzIKzojd4",
    projectId: "bhuprahari06",
    messagingSenderId: "275036991203",
    appId: "1:275036991203:android:3c1ea18c22b51d95921fd6",
  );
}
