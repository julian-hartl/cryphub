import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'favorite_currencies_notifier_event.dart';
part 'favorite_currencies_notifier_state.dart';
part 'favorite_currencies_notifier_bloc.freezed.dart';

@lazySingleton
class FavoriteCurrenciesNotifierBloc extends Bloc<
    FavoriteCurrenciesNotifierEvent, FavoriteCurrenciesNotifierState> {
  FavoriteCurrenciesNotifierBloc() : super(const _Initial()) {
    on<_MarkedCurrencyAsFavoriteSuccessfully>((event, emit) {
      emit(FavoriteCurrenciesNotifierState.markCurrencyAsFavoriteSuccess(
          event.symbol));
    });

    on<_ErrorMarkingCurrencyAsFavorite>((event, emit) {
      emit(FavoriteCurrenciesNotifierState.markCurrencyAsFavoriteError(
          event.symbol, 'Could not mark ${event.symbol} as favorite.'));
    });

    on<_RemovedCurrencyFromFavoritesSuccessfully>((event, emit) {
      emit(FavoriteCurrenciesNotifierState.removeCurrencyFromFavoritesSuccess(
        event.symbol,
      ));
    });

    on<_ErrorRemovingCurrencyFromFavorites>((event, emit) {
      emit(FavoriteCurrenciesNotifierState.removeCurrencyFromFavoritesError(
          event.symbol, 'Could not remove ${event.symbol} from favorites.'));
    });
  }
}
