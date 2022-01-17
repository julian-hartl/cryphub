import 'package:cryphub/constants.dart';
import 'package:cryphub/domain/network/network_response.dart';
import 'package:cryphub/domain/network/network_service.dart';
import 'package:cryphub/domain/network/network_timeout_exception.dart';

import '../../domain/application_directories.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:injectable/injectable.dart';

import '../../config.dart';
import '../../domain/core/api_exception.dart';
import '../../domain/core/logger/logger.dart';
import '../../domain/crypto_currency/crypto_currency.dart';
import '../../domain/crypto_currency/crypto_currency_repository.dart';
import '../utils/converters.dart';
import 'crypto_currency_cache.dart';

@LazySingleton(as: ICryptoCurrencyRepository)
class CryptoCurrencyRepository implements ICryptoCurrencyRepository {
  late final CryptoCurrencyCache cryptoCurrencyCache;
  final Logger logger;
  final ApplicationDirectories applicationDirectories;
  final INetworkService networkService;

  // late final _options = CacheOptions(
  //   store: HiveCacheStore(
  //     applicationDirectories.docDir,
  //     hiveBoxName: 'crypto_currencies_request_storage',
  //   ),
  //   maxStale: const Duration(minutes: 15),
  // );
  CryptoCurrencyRepository(
    this.cryptoCurrencyCache,
    this.logger,
    this.applicationDirectories,
    this.networkService,
  ) {
    // dio.interceptors.add(DioCacheInterceptor(options: _options));
  }

  /// first page is page = 1
  @override
  Future<List<CryptoCurrency>> getLatest(int page, int pageSize) async {
    try {
      // await Future.delayed(const Duration(seconds: 1));

      // return fakeCryptoCurrencies(pageSize);
      final response = await getFromCurrencyApi(
          '/cryptocurrency/listings/latest',
          queryParameters: {
            'limit': pageSize,
            'start': (page - 1) * pageSize + 1,
          });
      checkResponse(response);
      final data = response.data['data'] as List;
      final latest = data
          .map((json) => cryptoCurrencyFromApiListingsLatest(json))
          .toList();
      await cryptoCurrencyCache.cacheAndReplaceAll(latest);
      return latest;
    } catch (e) {
      logger.error(e);
      throw ApiException(e.toString());
    }
  }

  void checkResponse(NetworkResponse response) {
    if (response.status > 299) {
      throw ApiException(
          errorMessageFromApiError(response.data) ?? 'Unknown error.');
    }
  }

  // To see format in which the data is returned from the api, visit: https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyListingsHistorical
  CryptoCurrency cryptoCurrencyFromApiListingsLatest(
      Map<String, dynamic> json) {
    final id = json['id'];
    return CryptoCurrency(
      currentPrice: json['quote']['USD']['price'],
      percentChange1h: json['quote']['USD']['percent_change_1h'],
      percentChange24h: json['quote']['USD']['percent_change_24h'],
      percentChange7d: json['quote']['USD']['percent_change_7d'],
      symbol: json['symbol'],
      iconUrl: 'https://s2.coinmarketcap.com/static/img/coins/64x64/$id.png',
      name: json['name'],
      currency: Currency.usd,
      priceLastUpdated: DateTime.parse(json['quote']['USD']['last_updated']),
      id: id,
    );
  }

  @override
  Future<List<CryptoCurrency>> getCryptoCurrenciesByIds(List<int> ids) async {
    try {
      final cachedCryptoCurrencies = await cryptoCurrencyCache
          .getInTimespan(DateTime.now().subtract(const Duration(minutes: 10)));
      final modifiableIds = List<int>.from(ids, growable: true);
      final cachedCryptoCurrenciesWithIds = [];
      for (var element in cachedCryptoCurrencies) {
        modifiableIds.remove(element.id);
        if (ids.contains(element.id)) {
          cachedCryptoCurrenciesWithIds.add(element);
        }
      }
      ids = modifiableIds;

      final cryptoCurrenciesFromApi = await getCryptoCurrenciesBy(ids, "id");
      cryptoCurrencyCache.cacheAndReplaceAll(cryptoCurrenciesFromApi);
      return [...cachedCryptoCurrenciesWithIds, ...cryptoCurrenciesFromApi];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CryptoCurrency>> getCryptoCurrencyBySymbols(
      List<String> symbols) async {
    final cachedCryptoCurrencies = await cryptoCurrencyCache
        .getInTimespan(DateTime.now().subtract(const Duration(minutes: 10)));
    final modifiableSymbols = List<String>.from(symbols, growable: true);
    final cachedCryptoCurrenciesWithSymbols = [];

    for (var element in cachedCryptoCurrencies) {
      modifiableSymbols.remove(element.symbol);
      if (symbols.contains(element.symbol)) {
        cachedCryptoCurrenciesWithSymbols.add(element);
      }
    }
    symbols = modifiableSymbols;
    final cryptoCurrenciesFromApi =
        await getCryptoCurrenciesBy(symbols, 'symbol');
    cryptoCurrencyCache.cacheAndReplaceAll(cryptoCurrenciesFromApi);
    return [...cachedCryptoCurrenciesWithSymbols, ...cryptoCurrenciesFromApi];
  }

  /// [what] indicates which query paramter should be used to query crypto currencies
  Future<List<CryptoCurrency>> getCryptoCurrenciesBy(
      List l, String what) async {
    try {
      if (l.isEmpty) {
        return List.empty();
      } // https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyQuotesLatest
      final commaSeperated = seperateListValues(l);
      final response = await getFromCurrencyApi(
        '/cryptocurrency/quotes/latest',
        queryParameters: {what: commaSeperated},
      );
      checkResponse(response);

      final data = response.data['data'] as Map<String, dynamic>;
      final currencies = data.entries
          .map((entry) => cryptoCurrencyFromApiListingsLatest(entry.value))
          .toList();
      return currencies;
    } catch (e) {
      logger.error(e.toString());
      throw ApiException(e.toString());
    }
  }

  Future<NetworkResponse> getFromCurrencyApi(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await networkService.get(
      kCoinMarketCapApiUrl + path,
      headers: {'X-CMC_PRO_API_KEY': config.coinMarketCapApiKey},
      queryParameters: queryParameters,
    );
  }

  String? errorMessageFromApiError(dynamic data) {
    final String? errorMessage = data['status']['error_message'];
    return errorMessage;
  }

  // final Cache<CryptoCurrency> cryptoCurrencyCache = Cache();

  // void cacheCurrency(CryptoCurrency cryptoCurrency) {}
}
