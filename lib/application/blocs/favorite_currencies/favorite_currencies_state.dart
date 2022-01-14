part of 'favorite_currencies_bloc.dart';

@freezed
class FavoriteCurrenciesState with _$FavoriteCurrenciesState {
  const factory FavoriteCurrenciesState.updatedFavorites(
      KtList<CryptoCurrency> favorites) = _UpdatedFavorites;
  const factory FavoriteCurrenciesState.updating() = _Updating;
  const factory FavoriteCurrenciesState.error(String message) = _Error;
  // todo: maybe add different states for removing e.g.
}
