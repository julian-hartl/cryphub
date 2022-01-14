import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart' as logger;

@lazySingleton
class Logger {
  final logger.Logger log = logger.Logger();
  void info(dynamic info) {
    log.i(info);
  }

  void error(dynamic message) {
    log.e(message);
  }

  void warning(dynamic warning) {
    log.w(warning);
  }
}
