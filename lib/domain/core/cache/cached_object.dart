import 'json_mapper.dart';
import 'json_parsing_exception.dart';

class CachedObject<T, KeyType> {
  final T value;
  final JsonMapper<T>? jsonMapper;
  final KeyType key;
  final DateTime cachedAt;

  CachedObject(this.key, this.value, this.cachedAt, this.jsonMapper);

  bool hasKey(KeyType key) => this.key == key;

  Map<String, dynamic> toJson() => {
        'value': jsonMapper?.toJson(value) ?? value,
        'key': key,
        'cached_at': cachedAt.toIso8601String(),
      };

  factory CachedObject.fromJson(
      Map<String, dynamic> json, JsonMapper<T>? jsonMapper) {
    try {
      return CachedObject(
        json['key'],
        jsonMapper?.fromJson(json['value'].cast<String, dynamic>()) ??
            json['value'],
        DateTime.parse(json['cached_at']),
        jsonMapper,
      );
    } catch (e) {
      throw JsonParsingException(e.toString());
    }
  }

  @override
  String toString() => 'CachedObject(value: $value, key: $key)';
}
