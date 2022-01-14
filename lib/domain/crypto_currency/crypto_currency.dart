// ignore_for_file: invalid_annotation_target

import 'package:cryphub/domain/crypto_currency/currency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
export 'currency.dart';

part 'crypto_currency.freezed.dart';
part 'crypto_currency.g.dart';

@freezed
class CryptoCurrency with _$CryptoCurrency {
  const factory CryptoCurrency({
    @JsonKey(name: 'current_price') required double currentPrice,
    @JsonKey(name: 'percent_change_1h') required double percentChange1h,
    @JsonKey(name: 'percent_change_24h') required double percentChange24h,
    @JsonKey(name: 'percent_change_7d') required double percentChange7d,
    required String symbol,
    @JsonKey(name: 'icon_url') required String iconUrl,
    required String name,
    required Currency currency,
    @JsonKey(name: 'price_last_updated') required DateTime priceLastUpdated,
    required int id,
  }) = _CryptoCurrency;

  factory CryptoCurrency.fromJson(Map<String, dynamic> json) =>
      _$CryptoCurrencyFromJson(json);
}
