part of 'favorite_currencies_bloc.dart';

@freezed
class FavoriteCurrenciesEvent with _$FavoriteCurrenciesEvent {
  const factory FavoriteCurrenciesEvent.loadFavorites() = _LoadFavorites;
  const factory FavoriteCurrenciesEvent.markAsFavorite(String symbol) =
      _MarkAsFavorite;
  const factory FavoriteCurrenciesEvent.removeFromFavorites(String symbol) =
      _RemoveFromFavorites;
}
