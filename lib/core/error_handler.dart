import 'dart:async';
import 'dart:io';

import 'package:cryphub/application/screens/error_screen/error_screen.dart';
import 'package:cryphub/core/cryphub.dart';
import 'package:cryphub/domain/core/logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'configure_dependencies.dart';

class ErrorHandler {
  ErrorHandler({required Widget child}) {
    runZonedGuarded(() async {
      if (kReleaseMode) {
        ErrorWidget.builder = (details) => ErrorScreen(
              details: details,
            );
      }
      WidgetsFlutterBinding.ensureInitialized();

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
        app.get<Logger>().error('Uncaught exception.', error, stack);
      }
    });
  }
}
