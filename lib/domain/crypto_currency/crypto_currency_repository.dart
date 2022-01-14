import 'crypto_currency.dart';

abstract class ICryptoCurrencyRepository {
  Future<List<CryptoCurrency>> getLatest(int page, int pageSize);
  Future<List<CryptoCurrency>> getCryptoCurrencyBySymbols(List<String> symbols);
  Future<List<CryptoCurrency>> getCryptoCurrenciesByIds(List<int> ids);
}
