import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_merger/core/di/di.dart';
import 'package:text_merger/root_app.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      // In a real app, log this to a crash reporting service (e.g., Sentry)
      debugPrint('Flutter error: ${details.exceptionAsString()}');
    };

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    

    await init();

    runApp(const ToastificationWrapper(child: RootApp()));
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        library: 'Flutter test framework',
        context: ErrorSummary('while running async test code'),
      ),
    );

    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error initializing app: $error $stackTrace')),
        ),
      ),
    );
  }
}
