import 'package:logger/logger.dart' as logger;

class Logger {
  final String name;

  Logger(this.name);

  final logger.Logger _log = logger.Logger();

  /// Log at message level info
  void info(dynamic info) {
    _log.i('$name: $info');
  }

  /// Log at message level error
  void error(dynamic message, [Object? error, StackTrace? stackTrace]) {
    _log.e('$name: $message', error, stackTrace);
  }

  /// Log at message level warning
  void warning(dynamic warning) {
    _log.w('$name: $info');
  }
}
