import 'cache_exception.dart';

class JsonParsingException extends CacheException {
  JsonParsingException()
      : super('Could not parse json. Please check the provided [JsonMapper]');
}
