import '../../domain/crypto_currency/currency.dart';

String convertCurrencyToSymbol(Currency currency) {
  switch (currency) {
    case Currency.usd:
      return '\$';
  }
}

/// Converts a list to a [string] with their values seperated by commas
/// For example: ['Hello', 'World'] would become Hello, World
String seperateListValues<T extends Object?>(List<T> l) {
  String result = '';
  for (int i = 0; i < l.length; i++) {
    final isLastElement = i == l.length - 1;
    if (isLastElement) {
      result += l[i].toString();
    } else {
      result += '${l[i]},';
    }
  }
  return result;
}
