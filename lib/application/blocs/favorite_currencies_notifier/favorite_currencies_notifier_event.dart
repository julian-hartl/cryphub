part of 'favorite_currencies_notifier_bloc.dart';

@freezed
class FavoriteCurrenciesNotifierEvent with _$FavoriteCurrenciesNotifierEvent {
  const factory FavoriteCurrenciesNotifierEvent.markedCurrencyAsFavoriteSuccessfully(
    String symbol,
  ) = _MarkedCurrencyAsFavoriteSuccessfully;
  const factory FavoriteCurrenciesNotifierEvent.errorMarkingCurrencyAsFavorite(
    String symbol,
  ) = _ErrorMarkingCurrencyAsFavorite;

  const factory FavoriteCurrenciesNotifierEvent.removedCurrencyFromFavoritesSuccessfully(
    String symbol,
  ) = _RemovedCurrencyFromFavoritesSuccessfully;
  const factory FavoriteCurrenciesNotifierEvent.errorRemovingCurrencyFromFavorites(
    String symbol,
  ) = _ErrorRemovingCurrencyFromFavorites;
}
