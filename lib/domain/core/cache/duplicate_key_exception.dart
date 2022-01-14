import 'cache_exception.dart';

class DuplicateKeyException extends CacheException {
  final dynamic key;

  DuplicateKeyException(this.key) : super('Key $key is already in use.');
}
