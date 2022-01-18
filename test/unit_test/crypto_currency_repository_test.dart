import 'package:cryphub/core/config.dart';
import 'package:cryphub/core/configure_dependencies.dart';
import 'package:cryphub/core/constants.dart';
import 'package:cryphub/data/crypto_currency/crypto_currency_cache.dart';
import 'package:cryphub/data/crypto_currency/crypto_currency_repository.dart';
import 'package:cryphub/data/utils/converters.dart';
import 'package:cryphub/domain/application_directories.dart';
import 'package:cryphub/domain/core/api_exception.dart';
import 'package:cryphub/domain/core/cache/cache.dart';
import 'package:cryphub/domain/core/logger/logger.dart';
import 'package:cryphub/domain/network/network_response.dart';
import 'package:cryphub/domain/network/network_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'crypto_currency_repository_test.mocks.dart';
import 'helpers/data_sets.dart';
import 'helpers/functions.dart' as helpers;

@GenerateMocks([INetworkService])
void main() {
  String serverError(String path, DioAdapter dioAdapter) {
    const errorMessage = 'This is an error message';
    dioAdapter.onGet(kCoinMarketCapApiUrl + path, (server) {
      server.reply(400, {
        'status': {'error_message': errorMessage}
      });
    });
    return errorMessage;
  }

  group('CryptoCurrencyRepository', () {
    late CryptoCurrencyRepository sut;
    late CryptoCurrencyCache cryptoCurrencyCache;
    late MockINetworkService networkService;
    setUpAll(() async {
      await Cache.init();
      await configureDependencies();
    });
    setUp(() {
      networkService = MockINetworkService();
      cryptoCurrencyCache = CryptoCurrencyCache(
        cacheDirectory: 'test_crypto_currencies',
      );
      sut = CryptoCurrencyRepository(
        cryptoCurrencyCache,
        Logger(),
        app.get<ApplicationDirectories>(),
        networkService,
      );
    });
    tearDown(() async {
      await cryptoCurrencyCache.eraseAll();
    });
    test('Get from currency url', () async {
      const path = '/api';
      const status = 200;
      final mockData = {'mock': 12};
      final url = kCoinMarketCapApiUrl + path;
      final queryParameters = {'parameter': 1};
      when(networkService.get(
        url,
        headers: anyNamed('headers'),
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async {
        return NetworkResponse(status: status, data: mockData);
      });
      final response =
          await sut.getFromCurrencyApi(path, queryParameters: queryParameters);
      // latest request

      expect(response.status, equals(status));
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
      final url = kCoinMarketCapApiUrl + '/cryptocurrency/listings/latest';
      final data = latestDataJson;
      final cryptoCurrencies = latestCurrencies;
      const pageSize = 20;
      when(networkService.get(
        url,
        headers: anyNamed('headers'),
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async {
        return NetworkResponse(status: 200, data: data);
      });

      final latest = await sut.getLatest(1, pageSize);
      expect(latest, equals(cryptoCurrencies));
    });

    test('getLatest error', () async {
      const pageSize = 20;

      helpers.throwsA<ApiException>(() => sut.getLatest(1, pageSize));
    });

    test('getCurrenciesByIds', () async {
      final url = kCoinMarketCapApiUrl + '/cryptocurrency/quotes/latest';
      const data = quotesLatestIdsDataJson;
      when(networkService.get(
        url,
        headers: anyNamed('headers'),
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async {
        return const NetworkResponse(status: 200, data: data);
      });

      final currencies = await sut.getCryptoCurrenciesByIds(quotesLatestIds);
      expect(currencies, equals(quotesLatestCurrencies));
      verify(
        networkService.get(
          url,
          queryParameters: {'id': seperateListValues(quotesLatestIds)},
          headers: {
            'X-CMC_PRO_API_KEY': config.coinMarketCapApiKey,
          },
        ),
      );
    });

    test('getCurrenciesByIds error', () async {
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
      final url = kCoinMarketCapApiUrl + '/cryptocurrency/quotes/latest';

      const data = quotesLatestSymbolsDataJson;
      when(networkService.get(
        url,
        headers: anyNamed('headers'),
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async {
        return const NetworkResponse(status: 200, data: data);
      });

      final currencies =
          await sut.getCryptoCurrencyBySymbols(quotesLatestSymbols);
      expect(currencies, equals(quotesLatestCurrencies));
      verify(
        networkService.get(
          url,
          queryParameters: {'symbol': seperateListValues(quotesLatestSymbols)},
          headers: {
            'X-CMC_PRO_API_KEY': config.coinMarketCapApiKey,
          },
        ),
      );
    });

    test('getCurrenciesBySymbols returns empty list when empty list is passed',
        () async {
      final currencies = await sut.getCryptoCurrencyBySymbols([]);
      expect(currencies, equals([]));
    });

    test('getCurrenciesBySymbols error', () async {
      helpers.throwsA<ApiException>(
        () async => sut.getCryptoCurrencyBySymbols(quotesLatestSymbols),
      );
    });

    test('getLatest should cache the returned data', () async {
      final url = kCoinMarketCapApiUrl + '/cryptocurrency/listings/latest';

      final data = latestDataJson;
      final cryptoCurrencies = latestCurrencies;
      const pageSize = 20;
      when(networkService.get(
        url,
        headers: anyNamed('headers'),
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async {
        return NetworkResponse(status: 200, data: data);
      });

      await sut.getLatest(1, pageSize);
      expect(cryptoCurrencyCache.cached, equals(cryptoCurrencies));
    });
  });
}
