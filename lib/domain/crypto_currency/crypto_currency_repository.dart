import 'crypto_currency.dart';

abstract class ICryptoCurrencyRepository {
  /// Returns [pageSize] latest currencies from api.
  /// [page] starts at 1.
  /// Throws an [ApiException] when the api request fails.
  Future<List<CryptoCurrency>> getLatest(int page, int pageSize);

  /// Returns crypto currencies with the passed [symbols].
  /// Throws an [ApiException] when the api request fails.
  Future<List<CryptoCurrency>> getCryptoCurrencyBySymbols(List<String> symbols);

  /// Returns crypto currencies with the passed [ids].
  /// Throws an [ApiException] when the api request fails.
  Future<List<CryptoCurrency>> getCryptoCurrenciesByIds(List<int> ids);
}
