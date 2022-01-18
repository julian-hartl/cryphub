import 'package:cryphub/core/constants.dart';
import 'package:cryphub/data/logger/logger_provider.dart';
import 'package:cryphub/domain/network/network_response.dart';
import 'package:cryphub/domain/network/network_service.dart';
import 'package:injectable/injectable.dart';

import '../../core/config.dart';
import '../../domain/application_directories.dart';
import '../../domain/core/api_exception.dart';
import '../../domain/crypto_currency/crypto_currency.dart';
import '../../domain/crypto_currency/crypto_currency_repository.dart';
import '../utils/converters.dart';
import 'crypto_currency_cache.dart';

@LazySingleton(as: ICryptoCurrencyRepository)
class CryptoCurrencyRepository
    with LoggerProvider
    implements ICryptoCurrencyRepository {
  final CryptoCurrencyCache cryptoCurrencyCache;
  final ApplicationDirectories applicationDirectories;
  final INetworkService networkService;

  CryptoCurrencyRepository(
    this.cryptoCurrencyCache,
    this.applicationDirectories,
    this.networkService,
  ) {
    // dio.interceptors.add(DioCacheInterceptor(options: _options));
  }

  /// Specifies how long an item can live in the cache before being invalid
  static const cacheRefreshInterval = Duration(minutes: 10);

  @override
  Future<List<CryptoCurrency>> getLatest(int page, int pageSize) async {
    try {
      /// Makes a get request to https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest
      final response = await getFromCurrencyApi(
          '/cryptocurrency/listings/latest',
          queryParameters: {
            /// Specifies how many items are returned
            'limit': pageSize,

            /// Start is index from where items start to be returned
            /// For example, when a list like `["Hello", "World"]` is present in the databas and `start` is 2,
            /// it will return ["World"]
            'start': (page - 1) * pageSize + 1,
          });
      checkResponse(response);
      final data = response.data['data'] as List;
      final latest =
          data.map((json) => cryptoCurrencyFromApiReponse(json)).toList();
      await cryptoCurrencyCache.cacheAndReplaceAll(latest);
      return latest;
    } catch (e, st) {
      logger.error('', e, st);
      throw ApiException(e.toString());
    }
  }

  @override
  Future<List<CryptoCurrency>> getCryptoCurrenciesByIds(List<int> ids) async {
    try {
      final cachedCryptoCurrencies = await cryptoCurrencyCache
          .getInTimespan(DateTime.now().subtract(cacheRefreshInterval));
      // Makes list modifiable
      final notCachedCurrenciesIds = List<int>.from(ids, growable: true);
      // Stores all already cached items
      final cachedCryptoCurrenciesWithIds = [];
      for (var element in cachedCryptoCurrencies) {
        notCachedCurrenciesIds.remove(element.id);
        if (ids.contains(element.id)) {
          cachedCryptoCurrenciesWithIds.add(element);
        }
      }
      ids = notCachedCurrenciesIds;

      final cryptoCurrenciesFromApi = await getCryptoCurrenciesBy(ids, "id");
      cryptoCurrencyCache.cacheAndReplaceAll(cryptoCurrenciesFromApi);
      return [...cachedCryptoCurrenciesWithIds, ...cryptoCurrenciesFromApi];
    } catch (e, st) {
      logger.error('', e, st);
      rethrow;
    }
  }

  @override
  Future<List<CryptoCurrency>> getCryptoCurrencyBySymbols(
      List<String> symbols) async {
    try {
      final cachedCryptoCurrencies = await cryptoCurrencyCache
          .getInTimespan(DateTime.now().subtract(const Duration(minutes: 10)));
      final notCachedCryptoCurrencies =
          List<String>.from(symbols, growable: true);
      final cachedCryptoCurrenciesWithSymbols = [];

      for (var element in cachedCryptoCurrencies) {
        notCachedCryptoCurrencies.remove(element.symbol);
        if (symbols.contains(element.symbol)) {
          cachedCryptoCurrenciesWithSymbols.add(element);
        }
      }
      symbols = notCachedCryptoCurrencies;
      final cryptoCurrenciesFromApi =
          await getCryptoCurrenciesBy(symbols, 'symbol');
      cryptoCurrencyCache.cacheAndReplaceAll(cryptoCurrenciesFromApi);
      return [...cachedCryptoCurrenciesWithSymbols, ...cryptoCurrenciesFromApi];
    } catch (e, st) {
      logger.error('', e, st);
      rethrow;
    }
  }

  /// [cryptoCurrenciesQueryParamter] indicates which query paramter should be used to query crypto currencies.
  ///
  /// Does not catch exceptions.
  ///
  /// See https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyQuotesLatest .
  Future<List<CryptoCurrency>> getCryptoCurrenciesBy(
      List cryptoCurrenciesIdentifieres,
      String cryptoCurrenciesQueryParamter) async {
    if (cryptoCurrenciesIdentifieres.isEmpty) {
      return List.empty();
    }
    final commaSeperated = seperateListValues(cryptoCurrenciesIdentifieres);
    final response = await getFromCurrencyApi(
      '/cryptocurrency/quotes/latest',
      queryParameters: {cryptoCurrenciesQueryParamter: commaSeperated},
    );
    checkResponse(response);

    final data = response.data['data'] as Map<String, dynamic>;
    final currencies = data.entries
        .map((entry) => cryptoCurrencyFromApiReponse(entry.value))
        .toList();
    return currencies;
  }

  /// Makes a get request to [kCoinMarketCapApiUrl] + [path]
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

  /// Checks wether the request was successful or not.
  ///
  /// Throws an [ApiException] when it was not successful.
  ///
  /// Does nothing when it was successful.
  void checkResponse(NetworkResponse response) {
    if (response.status > 299) {
      throw ApiException(
          errorMessageFromApiError(response.data) ?? 'Unknown error.');
    }
  }

  /// To see format in which the data is returned from the api, visit: https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyListingsHistorical
  CryptoCurrency cryptoCurrencyFromApiReponse(Map<String, dynamic> json) {
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

  /// Returns the error messsage from returned [data]
  String? errorMessageFromApiError(dynamic data) {
    final String? errorMessage = data['status']['error_message'];
    return errorMessage;
  }
}
