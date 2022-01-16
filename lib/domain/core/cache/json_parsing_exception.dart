import 'cache_exception.dart';

class JsonParsingException extends CacheException {
  JsonParsingException(String reason)
      : super(
            'Could not parse json. Please check the provided [JsonMapper].\nReason: $reason');
}
