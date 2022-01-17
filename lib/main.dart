import 'dart:async';
import 'dart:io';

import 'package:cryphub/application/screens/error_screen/error_screen.dart';
import 'package:cryphub/configure_dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'cryphub.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    ErrorWidget.builder = (details) => ErrorScreen(
          details: details,
        );
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kReleaseMode) {
        exit(1);
      } else {
        FlutterError.presentError(details);
      }
    };
    // https://stackoverflow.com/questions/50322054/flutter-how-to-set-and-lock-screen-orientation-on-demand
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await configureDependencies();
    runApp(Cryphub());
  }, (Object error, StackTrace stack) {
    if (kReleaseMode) {
      exit(1);
    } else {
      debugPrint(stack.toString());
    }
  });
}
