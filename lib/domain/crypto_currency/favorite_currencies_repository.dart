/// Requires [GetStorage] to be initialized.
/// ```dart
/// await GetStorage.init();
/// ```
abstract class IFavoriteCurrenicesRepository {
  /// Marks currency with [symbol] as favorite.
  Future<void> markCurrencyAsFavorite(String symbol);

  /// Returns the symbols of all favorite currencies.
  Future<List<String>> getFavorites();

  /// Removes currency with [symbol] from favorites.
  Future<void> removeCurrencyFromFavorites(String symbol);
}
