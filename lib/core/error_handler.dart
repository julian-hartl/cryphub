import 'dart:async';

import 'package:cryphub/application/screens/error_screen/error_screen.dart';
import 'package:cryphub/data/logger/logger_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorHandler with LoggerProvider {
  ErrorHandler({required Widget child}) {
    runZonedGuarded(() async {
      if (kReleaseMode) {
        ErrorWidget.builder = (details) => ErrorScreen(
              details: details,
            );
      }

      FlutterError.onError = (FlutterErrorDetails details) {
        if (kReleaseMode) {
          Zone.current.handleUncaughtError(details.exception, details.stack!);
        } else {
          FlutterError.dumpErrorToConsole(details);
        }
      };
      // https://stackoverflow.com/questions/50322054/flutter-how-to-set-and-lock-screen-orientation-on-demand
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      runApp(child);
    }, (Object error, StackTrace stack) {
      if (kReleaseMode) {
        // report error
      } else {
        logger.error('Uncaught exception.', error, stack);
      }
    });
  }
}
