part of 'favorite_currencies_notifier_bloc.dart';

@freezed
class FavoriteCurrenciesNotifierState with _$FavoriteCurrenciesNotifierState {
  const factory FavoriteCurrenciesNotifierState.markCurrencyAsFavoriteSuccess(
    String symbol,
  ) = _MarkCurrencyAsFavoriteSuccess;
  const factory FavoriteCurrenciesNotifierState.markCurrencyAsFavoriteError(
    String symbol,
    String message,
  ) = _MarkedCurrencyAsFavoriteError;

  const factory FavoriteCurrenciesNotifierState.removeCurrencyFromFavoritesSuccess(
    String symbol,
  ) = _RemoveCurrencyFromFavoritesSuccess;
  const factory FavoriteCurrenciesNotifierState.removeCurrencyFromFavoritesError(
    String symbol,
    String message,
  ) = _RemoveCurrencyFromFavoritesError;
  const factory FavoriteCurrenciesNotifierState.initial() = _Initial;
}
