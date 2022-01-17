import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

import '../../domain/core/logger/logger.dart';
import '../../domain/crypto_currency/favorite_currencies_repository.dart';
import 'marked_currency_as_favorite_twice_exception.dart';

@LazySingleton(as: IFavoriteCurrenicesRepository)
class FavoriteCurrenciesRepository implements IFavoriteCurrenicesRepository {
  late final GetStorage storage;
  final Logger logger;

  FavoriteCurrenciesRepository(this.storage, this.logger);

  List<String>? _favoritesSymbols;

  @override
  Future<List<String>> getFavorites() async {
    await _initFavoritesSymbols();
    logger.info(_favoritesSymbols);
    return _favoritesSymbols!;
  }

  Future<void> _initFavoritesSymbols() async {
    try {
      await storage.initStorage;
      final favorites = storage.read<List>('favorites');

      _favoritesSymbols ??=
          List<String>.from(favorites?.cast<String>() ?? [], growable: true);
    } catch (e) {
      logger.error(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> markCurrencyAsFavorite(String symbol) async {
    try {
      await storage.initStorage;
      await _initFavoritesSymbols();

      if (_favoritesSymbols!.contains(symbol)) {
        throw MarkedCurrencyAsFavoriteTwiceException();
      }
      _favoritesSymbols!.add(symbol);
      await storage.write('favorites', _favoritesSymbols);
    } catch (e) {
      logger.error(e.toString());

      rethrow;
    }
  }

  @override
  Future<void> removeCurrencyFromFavorites(String symbol) async {
    try {
      _favoritesSymbols?.remove(symbol);
      await storage.write('favorites', _favoritesSymbols);
    } catch (e) {
      logger.error(e.toString());

      rethrow;
    }
  }
}
