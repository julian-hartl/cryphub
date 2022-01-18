import 'package:cryphub/domain/core/logger/logger.dart';

mixin LoggerProvider {
  Logger get logger => Logger('$runtimeType');
}
