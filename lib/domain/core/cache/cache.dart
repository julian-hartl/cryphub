import 'package:cryphub/domain/core/cache/unsupported_key_type_exception.dart';
import 'package:flutter/foundation.dart';

import 'already_initialized_exception.dart';
import 'cache_not_initialized_exception.dart';
import 'cached_object.dart';
import 'duplicate_key_exception.dart';
import 'json_mapper.dart';
import 'key_not_found_exception.dart';
import 'package:hive_flutter/adapters.dart';

class Cache<T, KeyType> {
  final List<CachedObject<T, KeyType>> _cached = [];

  //final bool Function(List<T> cache, T itemToAdd) alreadyExists;

  Cache(this.cacheDirectory, {this.jsonMapper, required this.getKey}) {
    if (KeyType != String && KeyType != int) {
      throw UnsupportedKeyTypeException(KeyType);
    }
  }

  /// The directory that is used to store data in local storage
  final String cacheDirectory;

  final JsonMapper<T>? jsonMapper;

  /// returns the key that is used to store objects in local storage
  /// make sure that the returned value either overrides equality or extends [Equatable] to ensure working equality
  final KeyType Function(T value) getKey;

  late final Box<Map> _cacheBox;
  bool _initialized = false;

  /// Returns all cached items
  /// Throws a [CacheNotInitializedException] when initialize has been not been called yet
  List<T> get cached {
    if (!_initialized) throw CacheNotInitializedException();
    return _cached.map((cachedO) => cachedO.value).toList();
  }

  /// caches the [item]
  Future<void> cache(T item) async {
    return await cacheAll([item]);
  }

  /// Caches all [items]
  /// Throws a [DuplicateKeyException] when an item is added with a key that already exists
  Future<void> cacheAll(List<T> items, {bool replace = false}) async {
    await _checkInitialization();
    final entries = items.map((value) {
      final key = getKey(value);
      return CachedObject<T, KeyType>(key, value, DateTime.now(), jsonMapper);
    });
    for (var cachedObject in entries) {
      final alreadyExists = await keyExists(cachedObject.key);

      if (alreadyExists) {
        if (replace) {
          await delete(cachedObject.key);
        } else {
          throw DuplicateKeyException(cachedObject.key);
        }
      }
    }
    _cached.addAll(entries);
    final Map<dynamic, Map<String, dynamic>> boxEntry = {};
    for (var element in entries) {
      boxEntry[element.key] = element.toJson();
    }
    await _cacheBox.putAll(boxEntry);
  }

  Future<void> _checkInitialization() async {
    if (!_initialized) await initialize();
  }

  /// Loads data from local storage
  /// Throws an [AlreadyInitializedException] when the cache has alredy been initialized
  Future<void> initialize() async {
    if (_initialized) {
      throw AlreadyInitializedException();
    }
    _cacheBox = await Hive.openBox(cacheDirectory);

    debugPrint(_cacheBox.values.toString());

    _cached.addAll(_cacheBox.values.map((json) =>
        CachedObject.fromJson(json.cast<String, dynamic>(), jsonMapper)));
    _initialized = true;
  }

  /// Returns `true` when the key exists
  /// Returns `false` when the key does not exist
  Future<bool> keyExists(KeyType key) async {
    try {
      await getByKey(key);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Gets an object from the cache with the specified [key]
  /// Throws a [KeyNotFoundException] when object with [key] is not found
  Future<T> getByKey(KeyType key) async {
    await _checkInitialization();
    try {
      return _cached.firstWhere((element) => element.hasKey(key)).value;
    } catch (_) {
      throw KeyNotFoundException(key);
    }
  }

  /// Deletes an item with the specified [key]
  /// Throws a [KeyNotFoundException] when [key] does not exist
  Future<void> delete(KeyType key) async {
    if (await keyExists(key)) {
      await _cacheBox.delete(key);
      _cached.removeWhere((cachedO) => cachedO.key == key);
    } else {
      throw KeyNotFoundException(key);
    }
  }

  /// Erases everything in the cache
  Future<void> eraseAll() async {
    await _checkInitialization();
    await _cacheBox.clear();
    _cached.clear();
  }

  Future<List<T>> getInTimespan(DateTime from, {DateTime? until}) async {
    await _checkInitialization();
    until ??= DateTime.now();
    return _cached
        .where((element) =>
            element.cachedAt.isAfter(from) && element.cachedAt.isBefore(until!))
        .toList()
        .map((cachedObject) => cachedObject.value)
        .toList();
  }

  /// Call this method before using any [Cache] instance
  static Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<void> cacheAndReplace(T item) async {
    await cacheAndReplaceAll([item]);
  }

  Future<void> cacheAndReplaceAll(List<T> items) async {
    await cacheAll(items, replace: true);
  }
}
