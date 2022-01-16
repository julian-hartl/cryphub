import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:cryphub/domain/core/cache/already_initialized_exception.dart';
import 'package:cryphub/domain/core/cache/cache.dart';
import 'package:cryphub/domain/core/cache/cache_not_initialized_exception.dart';
import 'package:cryphub/domain/core/cache/duplicate_key_exception.dart';
import 'package:cryphub/domain/core/cache/json_mapper.dart';
import 'package:cryphub/domain/core/cache/key_not_found_exception.dart';

import 'helpers/functions.dart' as helpers;

void main() {
  late Cache sut;
  const boxName = 'test';

  Cache<T> createCache<T>(
          {dynamic Function(T value)? getKey, JsonMapper<T>? jsonMapper}) =>
      Cache<T>(boxName, getKey: getKey, jsonMapper: jsonMapper);

  setUpAll(() async {
    await Cache.init();
    await Hive.deleteBoxFromDisk(boxName);
  });

  setUp(() {
    sut = createCache();
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(boxName);
  });

  test('When item is cached, the cache should contain it', () async {
    const item = 'item';
    await sut.cache(item);
    expect(sut.cached, contains(item));
  });

  test(
      'When cache is initialized, it should load all existing data from a local data storage',
      () async {
    const item = 'jslfkjs';
    await sut.cache(item);
    sut = createCache();

    await sut.initialize();
    expect(sut.cached, contains(item));
  });

  test(
      'When initialize is called more than once, [Cache] should throw a [AlreadyInitializedException]',
      () async {
    try {
      await sut.initialize();
      await sut.initialize();
    } catch (e) {
      expect(e, isA<AlreadyInitializedException>());
      return;
    }
    fail('AlreadyInitializedException was not thrown.');
  });

  test('When getKey is not provided, it should use the objects value as a key',
      () async {
    const item = 'jklwjlekfw';
    await sut.cache(item);
    final result = await sut.getByKey(item);

    expect(result, equals(item));
  });

  test('When cacheAll is called, items should be present in the cache',
      () async {
    const items = ['item1', 'item2', 'item3'];
    await sut.cacheAll(items);

    expect(sut.cached, containsAll(items));
  });

  test('When cacheAll is called, items should be stored in local storage',
      () async {
    const items = ['item1', 'item2', 'item3'];
    await sut.cacheAll(items);
    sut = createCache();
    await sut.initialize();
    expect(sut.cached, containsAll(items));
  });

  test(
      'When cached is called and initialize has not been called, a [CacheNotInitializedException] should be thrown',
      () async {
    await helpers.throwsA<CacheNotInitializedException>(() async => sut.cached);
  });

  test(
      'When getByKey is called with a key that does not exist, a [KeyNotFoundException] should be thrown',
      () async {
    await helpers.throwsA<KeyNotFoundException>(
        () => sut.getByKey('someRandomKeyThatWillNeverExist'));
  });

  test(
      'When an item is cached with a key that already exists, a [DuplicateKeyException] is thrown',
      () async {
    const item = 'item9292';
    await sut.cache(item);
    await helpers.throwsA<DuplicateKeyException>(() => sut.cache(item));
  });

  test(
      'When items are cached with a key that already exists, a [DuplicateKeyException] is thrown',
      () async {
    const items = ['item9292', '9082109', 'kljwek'];
    await sut.cache(items[0]);
    await helpers.throwsA<DuplicateKeyException>(() => sut.cacheAll(items));
  });

  test(
      'keyExists should return true when object was cached with that key before',
      () async {
    const item = '2';
    await sut.cache(item);
    final result = await sut.keyExists(item);
    expect(result, equals(true));
  });

  test(
      'keyExists should return false when no object was cached with that key before',
      () async {
    const item = '2';
    final result = await sut.keyExists(item);
    expect(result, equals(false));
  });

  test(
      'when an object is cached with a custom key, the key should be used to get the object',
      () async {
    const key = 'key';
    const item = 'kjkwlefkwjl';
    sut = createCache(
      getKey: (_) => key,
    );
    await sut.cache(item);
    final exists = await sut.keyExists(key);
    expect(exists, equals(true));
  });

  test(
      'when jsonMapper is provided it should use toJson to pass complex objects',
      () async {
    const complexObject = ComplexObject(name: 'Julian', age: 10, id: 2);
    sut = createCache<ComplexObject>(
        getKey: (value) => value.id,
        jsonMapper: JsonMapper(
          fromJson: (json) => ComplexObject.fromMap(json),
          toJson: (value) => value.toMap(),
        ));
    await sut.cache(complexObject);

    final result = await sut.getByKey(complexObject.id);

    expect(result, equals(complexObject));
  });

  test(
      'when jsonMapper is provided it should use from json to pass complex objects from local storage',
      () async {
    const complexObjects = [
      ComplexObject(name: 'Julian', age: 10, id: 2),
      ComplexObject(name: 'Julian', age: 10, id: 3),
    ];
    sut = createCache<ComplexObject>(
        getKey: (value) => value.id,
        jsonMapper: JsonMapper(
          fromJson: (json) => ComplexObject.fromMap(json),
          toJson: (value) => value.toMap(),
        ));
    await sut.cacheAll(complexObjects);

    sut = createCache<ComplexObject>(
        getKey: (value) => value.id,
        jsonMapper: JsonMapper(
          fromJson: (json) => ComplexObject.fromMap(json),
          toJson: (value) => value.toMap(),
        ));

    final result = await sut.getByKey(complexObjects[0].id);

    expect(result, equals(complexObjects[0]));
  });

  test('When item is deleted, it should not exist anymore', () async {
    const item = 'wlekjw';
    await sut.cache(item);

    await sut.delete(item);
    final exists = await sut.keyExists(item);

    expect(exists, equals(false));
  });

  test(
      'When item is deleted, that does not exists, it should thrown a [KeyNotFoundException]',
      () async {
    helpers.throwsA<KeyNotFoundException>(() => sut.delete('randomkey'));
  });

  test(
      'When eraseAll is called, no previously cached item should exist anymore',
      () async {
    const items = ['1', '2', '3'];
    await sut.cacheAll(items);

    await sut.eraseAll();

    for (var item in items) {
      final exists = await sut.keyExists(item);
      expect(exists, equals(false));
    }
  });

  test(
      'getInTimespan should return all values cached in the specified timespan',
      () async {
    final from = DateTime.now();
    const items = ['Hello', 'World'];
    await sut.cacheAll(items);
    final result = await sut.getInTimespan(from);
    expect(result, equals(items));
  });

  test(
      'getInTimespan does not return values that weren\'t cached in the the specified timespan',
      () async {
    const items = ['Hello', 'World'];
    await sut.cacheAll(items);
    final from = DateTime.now();

    final result = await sut.getInTimespan(from);
    expect(result, equals([]));
  });

  test('cacheAndReplace should replace an existing value with the same key',
      () async {
    const complexObjects = [
      ComplexObject(name: 'Julian', age: 10, id: 2),
      ComplexObject(name: 'Julian', age: 12, id: 2),
    ];
    await sut.cache(complexObjects[0]);
    await sut.cacheAndReplace(complexObjects[1]);

    final result = await sut.getByKey(2);
    expect(result, equals(complexObjects[1]));
  });

  test(
      'cacheAndReplace should not replace an existing value with the a differnt key',
      () async {
    const complexObjects = [
      ComplexObject(name: 'Julian', age: 10, id: 3),
      ComplexObject(name: 'Julian', age: 12, id: 2),
    ];
    await sut.cache(complexObjects[0]);
    await sut.cacheAndReplace(complexObjects[1]);

    final id2 = await sut.getByKey(2);
    final id3 = await sut.getByKey(3);
    expect(id2, equals(complexObjects[1]));
    expect(id3, equals(complexObjects[0]));
  });

  test('cacheAndReplaceAll should replace existing values with the same key',
      () async {
    const complexObjects = [
      ComplexObject(name: 'Julian', age: 10, id: 2),
      ComplexObject(name: 'Julian', age: 12, id: 3),
    ];
    const complexObjectsReplacements = [
      ComplexObject(name: 'Julian', age: 12, id: 2),
      ComplexObject(name: 'Julian', age: 14, id: 3),
    ];
    await sut.cacheAll(complexObjects);
    await sut.cacheAndReplaceAll(complexObjectsReplacements);

    final result = await sut.getByKey(2);
    expect(result, equals(complexObjectsReplacements[0]));
  });

  test(
      'cacheAndReplace should not replace an existing value with the a differnt key',
      () async {
    const complexObjects = [
      ComplexObject(name: 'Julian', age: 10, id: 3),
      ComplexObject(name: 'Julian', age: 12, id: 2),
    ];
    await sut.cache(complexObjects[0]);
    await sut.cacheAndReplace(complexObjects[1]);

    final id2 = await sut.getByKey(2);
    final id3 = await sut.getByKey(3);
    expect(id2, equals(complexObjects[1]));
    expect(id3, equals(complexObjects[0]));
  });
}

class ComplexObject {
  final String name;
  final int age;
  final int id;
  const ComplexObject({
    required this.name,
    required this.age,
    required this.id,
  });

  ComplexObject copyWith({
    String? name,
    int? age,
    int? id,
  }) {
    return ComplexObject(
      name: name ?? this.name,
      age: age ?? this.age,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'id': id,
    };
  }

  factory ComplexObject.fromMap(Map<String, dynamic> map) {
    return ComplexObject(
      name: map['name'] ?? '',
      age: map['age']?.toInt() ?? 0,
      id: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ComplexObject.fromJson(String source) =>
      ComplexObject.fromMap(json.decode(source));

  @override
  String toString() => 'ComplexObject(name: $name, age: $age, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ComplexObject &&
        other.name == name &&
        other.age == age &&
        other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode ^ id.hashCode;
}
