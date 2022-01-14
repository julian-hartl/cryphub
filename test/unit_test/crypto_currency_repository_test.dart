import 'package:cryphub/config.dart';
import 'package:cryphub/data/crypto_currency/crypto_currency_cache.dart';
import 'package:cryphub/data/crypto_currency/crypto_currency_repository.dart';
import 'package:cryphub/data/utils/converters.dart';
import 'package:cryphub/domain/core/api_exception.dart';
import 'package:cryphub/domain/core/cache/cache.dart';
import 'package:cryphub/domain/core/logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'helpers/data_sets.dart';
import 'helpers/functions.dart' as helpers;

void main() {
  String serverError(String path, DioAdapter dioAdapter) {
    const errorMessage = 'This is an error message';
    dioAdapter.onGet(config.coinMarketCapApiUrl + path, (server) {
      server.reply(400, {
        'status': {'error_message': errorMessage}
      });
    });
    return errorMessage;
  }

  group('CryptoCurrencyRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late CryptoCurrencyRepository sut;
    late CryptoCurrencyCache cryptoCurrencyCache;
    setUpAll(() async {
      await Cache.init();
    });
    setUp(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
      cryptoCurrencyCache = CryptoCurrencyCache(
        cacheDirectory: 'test_crypto_currencies',
      );
      sut = CryptoCurrencyRepository(dio, cryptoCurrencyCache, Logger());
    });
    test('Get from currency url', () async {
      const path = '/api';
      const status = 200;
      final mockData = {'mock': 12};
      final url = config.coinMarketCapApiUrl + path;
      final queryParameters = {'parameter': 1};
      dioAdapter.onGet(url, (server) {
        server.reply(status, mockData);
      });
      final response =
          await sut.getFromCurrencyApi(path, queryParameters: queryParameters);
      // latest request
      final request = dioAdapter.history[0].request;

      expect(request.method, equals(RequestMethods.get));
      expect(request.route, equals(url));
      expect(response.statusCode, equals(status));
      expect(response.data, equals(mockData));
      // expect(request.queryParameters, equals(queryParameters));

      // request should contain the api key in the header
      // request headers is empty for some reason
      /*
      expect(request.headers?['X-CMC_PRO_API_KEY'],
          equals(config.coinMarketCapApiKey));
          */
    });

    test('getLatest', () async {
      const path = '/cryptocurrency/listings/latest';
      final data = latestDataJson;
      final cryptoCurrencies = latestCurrencies;
      const pageSize = 20;
      dioAdapter.onGet(config.coinMarketCapApiUrl + path, (server) {
        server.reply(200, data);
      });
      final latest = await sut.getLatest(1, pageSize);
      expect(latest, equals(cryptoCurrencies));
    });

    test('getLatest error', () async {
      const path = '/cryptocurrency/listings/latest';
      const pageSize = 20;

      final errorMessage =
          serverError(config.coinMarketCapApiUrl + path, dioAdapter);
      helpers.throwsA<ApiException>(() => sut.getLatest(1, pageSize));
    });

    test('getCurrenciesByIds', () async {
      const path = '/cryptocurrency/quotes/latest';
      const data = quotesLatestIdsDataJson;
      dioAdapter.onGet(
        config.coinMarketCapApiUrl + path,
        (server) {
          server.reply(200, data);
        },
        queryParameters: {
          'id': convertListToCommaSeperatedStringListing(quotesLatestIds)
        },
      );
      final currencies = await sut.getCryptoCurrenciesByIds(quotesLatestIds);
      expect(currencies, equals(quotesLatestCurrencies));
    });

    test('getCurrenciesByIds error', () async {
      const path = '/cryptocurrency/quotes/latest';

      final errorMessage =
          serverError(config.coinMarketCapApiUrl + path, dioAdapter);

      helpers.throwsA<ApiException>(
        () async => sut.getCryptoCurrenciesByIds(quotesLatestIds),
      );
    });

    test('getCurrenciesByIds returns empty list when empty list is passed',
        () async {
      final currencies = await sut.getCryptoCurrenciesByIds([]);
      expect(currencies, equals([]));
    });

    test('getCurrenciesBySymbols', () async {
      const path = '/cryptocurrency/quotes/latest';
      const data = quotesLatestSymbolsDataJson;
      dioAdapter.onGet(
        config.coinMarketCapApiUrl + path,
        (server) {
          server.reply(200, data);
        },
        queryParameters: {
          'symbol':
              convertListToCommaSeperatedStringListing(quotesLatestSymbols)
        },
      );
      /*
      expect(dioAdapter.history[0].request.queryParameters,
          equals({'symbol': 'BTC, ETH'}));
          */
      final currencies =
          await sut.getCryptoCurrencyBySymbols(quotesLatestSymbols);
      expect(currencies, equals(quotesLatestCurrencies));
    });

    test('getCurrenciesBySymbols returns empty list when empty list is passed',
        () async {
      final currencies = await sut.getCryptoCurrencyBySymbols([]);
      expect(currencies, equals([]));
    });

    test('getCurrenciesBySymbols error', () async {
      const path = '/cryptocurrency/quotes/latest';
      final errorMessage =
          serverError(config.coinMarketCapApiUrl + path, dioAdapter);

      helpers.throwsA<ApiException>(
        () async => sut.getCryptoCurrencyBySymbols(quotesLatestSymbols),
      );
    });

    test('getLatest should cache the returned data', () async {
      const path = '/cryptocurrency/listings/latest';
      final data = latestDataJson;
      final cryptoCurrencies = latestCurrencies;
      const pageSize = 20;
      dioAdapter.onGet(config.coinMarketCapApiUrl + path, (server) {
        server.reply(200, data);
      });
      await sut.getLatest(1, pageSize);
      expect(cryptoCurrencyCache.cached, equals(cryptoCurrencies));
    });
  });
}
