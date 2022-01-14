import 'package:cryphub/data/utils/converters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Converters', () {
    test('should return a comma seperated string of all the values in the list',
        () {
      const items = ['Hello', 'World', 'I', 'am', 'here'];
      final result = convertListToCommaSeperatedStringListing(items);
      expect(result, equals('Hello,World,I,am,here'));
    });
  });
}
