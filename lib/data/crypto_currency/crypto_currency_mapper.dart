import '../../domain/core/mapper.dart';
import '../../domain/crypto_currency/crypto_currency.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CryptoCurrencyMapper implements Mapper<CryptoCurrency> {
  const CryptoCurrencyMapper();

  @override
  CryptoCurrency fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();
  /*
  CryptoCurrency(
        currentPrice: json['current_price'],
        percentChange1h: json[],
        percentChange24h: percentChange24h,
        percentChange7d: percentChange7d,
        symbol: symbol,
        iconUrl: iconUrl,
        name: name,
        currency: currency,
        priceLastUpdated: priceLastUpdated,
        id: id,
      );
  */

  @override
  Map<String, dynamic> toJson(CryptoCurrency currency) {
    return {
      'id': currency.id,
      'symbol': currency.symbol,
      'name': currency.name,
      'current_price': currency.currentPrice,
    };
  }
}
