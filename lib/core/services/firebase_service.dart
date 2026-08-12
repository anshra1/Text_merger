import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
// import 'package:text_merger/firebase_options.dart'; // Uncomment after running flutterfire configure

class FirebaseService {
  bool get _isSupported => kIsWeb || (!Platform.isLinux && !Platform.isWindows);
  
  FirebaseAnalytics? _analytics;

  Future<void> init() async {
    if (!_isSupported) return;

    try {
      await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.currentPlatform, // Uncomment when options are available
      );
      
      _analytics = FirebaseAnalytics.instance;
      
      // Pass all uncaught "fatal" errors from the framework to Crashlytics
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      
      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }on Exception catch (e) {
      debugPrint('Failed to initialize Firebase: $e');
    }
  }

  void logEvent(String name, {Map<String, Object>? parameters}) {
    if (!_isSupported || _analytics == null) return;
    _analytics!.logEvent(name: name, parameters: parameters);
  }

  void recordError(dynamic exception, StackTrace? stack, {bool fatal = false}) {
    if (!_isSupported) return;
    FirebaseCrashlytics.instance.recordError(exception, stack, fatal: fatal);
  }
}
