import 'package:bloc/bloc.dart';
import 'package:cryphub/domain/core/logger/logger.dart';
import '../favorite_currencies_notifier/favorite_currencies_notifier_bloc.dart';
import '../../../domain/crypto_currency/crypto_currency.dart';
import '../../../domain/crypto_currency/crypto_currency_repository.dart';
import '../../../domain/crypto_currency/favorite_currencies_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

part 'favorite_currencies_event.dart';
part 'favorite_currencies_state.dart';
part 'favorite_currencies_bloc.freezed.dart';

@lazySingleton
class FavoriteCurrenciesBloc
    extends Bloc<FavoriteCurrenciesEvent, FavoriteCurrenciesState> {
  final IFavoriteCurrenicesRepository favoriteCurrenciesRepository;
  final ICryptoCurrencyRepository cryptoCurrencyRepository;
  final FavoriteCurrenciesNotifierBloc favoriteCurrenciesNotifier;
  final Logger logger;

  FavoriteCurrenciesBloc(
    this.favoriteCurrenciesRepository,
    this.cryptoCurrencyRepository,
    this.favoriteCurrenciesNotifier,
    this.logger,
  ) : super(const FavoriteCurrenciesState.updating()) {
    on<_LoadFavorites>((event, emit) async {
      try {
        final favoritesSymbols =
            await favoriteCurrenciesRepository.getFavorites();
        List<CryptoCurrency>? favorites;
        if (favoritesSymbols.isNotEmpty) {
          favorites = await cryptoCurrencyRepository
              .getCryptoCurrencyBySymbols(favoritesSymbols);
        }

        emit(FavoriteCurrenciesState.updatedFavorites(
            KtList.from(favorites ?? [])));
      } catch (e) {
        logger.warning(e);

        emit(const FavoriteCurrenciesState.error('Api exception occurred.'));
      }
    });
    on<_MarkAsFavorite>((event, emit) async {
      final currentFavorites = await _getCurrentFavorites();
      final toBeMarkedAsFavoriteSymbol = event.symbol;
      logger.info('Marking $toBeMarkedAsFavoriteSymbol as favorite...');

      try {
        await favoriteCurrenciesRepository
            .markCurrencyAsFavorite(toBeMarkedAsFavoriteSymbol);
        final toBeMarkedAsFavorite = (await cryptoCurrencyRepository
            .getCryptoCurrencyBySymbols([toBeMarkedAsFavoriteSymbol]))[0];

        currentFavorites.add(toBeMarkedAsFavorite);
        emit(FavoriteCurrenciesState.updatedFavorites(
            currentFavorites.toImmutableList()));
        favoriteCurrenciesNotifier.add(FavoriteCurrenciesNotifierEvent
            .markedCurrencyAsFavoriteSuccessfully(toBeMarkedAsFavoriteSymbol));
      } catch (e) {
        logger.warning(e);

        favoriteCurrenciesNotifier.add(
            FavoriteCurrenciesNotifierEvent.errorMarkingCurrencyAsFavorite(
                toBeMarkedAsFavoriteSymbol));
        emit(FavoriteCurrenciesState.updatedFavorites(
            currentFavorites.toImmutableList()));
      }
    });

    on<_RemoveFromFavorites>((event, emit) async {
      final symbolToRemove = event.symbol;

      try {
        await favoriteCurrenciesRepository
            .removeCurrencyFromFavorites(symbolToRemove);
        final favorites = await _getCurrentFavorites();
        emit(FavoriteCurrenciesState.updatedFavorites(
            favorites.toImmutableList()));
      } catch (e) {
        logger.warning(e);

        emit(FavoriteCurrenciesState.updatedFavorites(
            (await _getCurrentFavorites()).toImmutableList()));
        favoriteCurrenciesNotifier.add(
            FavoriteCurrenciesNotifierEvent.errorRemovingCurrencyFromFavorites(
                symbolToRemove));
      }
    });
  }

  Future<List<CryptoCurrency>> _getCurrentFavorites() async {
    return List.from(
      await cryptoCurrencyRepository.getCryptoCurrencyBySymbols(
        await favoriteCurrenciesRepository.getFavorites(),
      ),
      growable: true,
    );
  }
}
