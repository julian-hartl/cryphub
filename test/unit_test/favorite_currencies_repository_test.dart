import 'package:cryphub/data/crypto_currency/favorite_currencies_repository.dart';
import 'package:cryphub/data/crypto_currency/marked_currency_as_favorite_twice_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'helpers/data_sets.dart';

void main() {
  group('FavoriteCurrenciesRepository', () {
    late FavoriteCurrenciesRepository sut;

    late GetStorage storage;
    setUpAll(() async {
      await GetStorage.init();
    });
    setUp(() {
      storage = GetStorage('test-container');
      sut = FavoriteCurrenciesRepository(storage);
    });
    tearDown(() async {
      await storage.erase();
    });
    test('it should get an currency that was stored before', () async {
      // in memory test
      final currency = latestCurrencies[0];
      await sut.markCurrencyAsFavorite(currency.symbol);
      final mFavorites = await sut.getFavorites();
      expect(mFavorites, equals([currency.symbol]));

      // in storage test
      sut = FavoriteCurrenciesRepository(storage);
      final sFavorites = await sut.getFavorites();
      expect(sFavorites, equals([currency.symbol]));
    });

    test(
        'it should throw a [MarkedCurrencyAsFavoriteTwiceException] when currency is added twice',
        () async {
      // in memory test
      final currency = latestCurrencies[0];
      try {
        await sut.markCurrencyAsFavorite(currency.symbol);
        await sut.markCurrencyAsFavorite(currency.symbol);
      } catch (e) {
        expect(e, isA<MarkedCurrencyAsFavoriteTwiceException>());
        return;
      }
      fail('No exception was thrown');
    });
  });
}
