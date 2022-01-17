import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart' as logger;

@lazySingleton
class Logger {
  final logger.Logger _log = logger.Logger();

  /// Log at message level info
  void info(dynamic info) {
    _log.i(info);
  }

  /// Log at message level error
  void error(dynamic message) {
    _log.e(message);
  }

  /// Log at message level warning
  void warning(dynamic warning) {
    _log.w(warning);
  }
}
