import '../../domain/crypto_currency/crypto_currency.dart';

List<CryptoCurrency> fakeCryptoCurrencies(int amount) {
  final latestDataCurrency = CryptoCurrency(
    currentPrice: 9283.92,
    percentChange1h: -0.152774,
    percentChange24h: 0.518894,
    percentChange7d: 0.986573,
    symbol: "BTC",
    iconUrl: "https://s2.coinmarketcap.com/static/img/coins/64x64/1.png",
    name: "Bitcoin",
    currency: Currency.usd,
    priceLastUpdated: DateTime.parse("2018-08-09T22:53:32.000Z"),
    id: 1,
  );
  return List.generate(amount, (index) => latestDataCurrency);
}
