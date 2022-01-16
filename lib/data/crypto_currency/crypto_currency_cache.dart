import 'package:injectable/injectable.dart';

import '../../domain/core/cache/cache.dart';
import '../../domain/core/cache/json_mapper.dart';
import '../../domain/crypto_currency/crypto_currency.dart';

class CryptoCurrencyCache extends Cache<CryptoCurrency, String> {
  CryptoCurrencyCache({String? cacheDirectory})
      : super(
          cacheDirectory ?? 'crypto_currencies',
          getKey: (value) => value.symbol,
          jsonMapper: JsonMapper(
            fromJson: CryptoCurrency.fromJson,
            toJson: (value) => value.toJson(),
          ),
        );
}
