import 'package:flutter_test/flutter_test.dart';

Future<void> throwsA<T>(Future Function() callback) async {
  try {
    await callback.call();
  } catch (e) {
    expect(e, isA<T>());
    return;
  }
  fail('$T was not thrown.');
}
