abstract class IFavoriteCurrenicesRepository {
  Future<void> markCurrencyAsFavorite(String symbol);
  Future<List<String>> getFavorites();
  Future<void> removeCurrencyFromFavorites(String symbol);
}
