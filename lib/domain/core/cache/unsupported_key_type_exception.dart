import 'cache_exception.dart';

class UnsupportedKeyTypeException extends CacheException {
  UnsupportedKeyTypeException(Type keyType)
      : super('Key of type $keyType is not allowed. Either use string or int.');
}
