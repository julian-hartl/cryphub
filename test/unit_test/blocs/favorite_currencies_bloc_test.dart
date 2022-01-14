import 'package:bloc_test/bloc_test.dart';
import 'package:cryphub/application/blocs/favorite_currencies/favorite_currencies_bloc.dart';
import 'package:cryphub/application/blocs/favorite_currencies_notifier/favorite_currencies_notifier_bloc.dart';
import 'package:cryphub/data/crypto_currency/favorite_currencies_repository.dart';
import 'package:cryphub/data/crypto_currency/marked_currency_as_favorite_twice_exception.dart';
import 'package:cryphub/domain/core/api_exception.dart';
import 'package:cryphub/domain/crypto_currency/crypto_currency.dart';
import 'package:cryphub/domain/crypto_currency/crypto_currency_repository.dart';
import 'package:cryphub/domain/crypto_currency/favorite_currencies_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../helpers/data_sets.dart';

/*

void main() {
  late IFavoriteCurrenicesRepository favoriteCurrenicesRepository;
  late ICryptoCurrencyRepository cryptoCurrencyRepository;
  late FavoriteCurrenciesNotifierBloc favoriteCurrenciesNotifier;

  setUp(() {
    favoriteCurrenicesRepository = FavoriteCurrenciesRepository();
    cryptoCurrencyRepository = MockICryptoCurrencyRepository();
    favoriteCurrenciesNotifier = MockFavoriteCurrenciesNotifierBloc();
  });

  FavoriteCurrenciesBloc buildBloc() => FavoriteCurrenciesBloc(
        favoriteCurrenicesRepository,
        cryptoCurrencyRepository,
        favoriteCurrenciesNotifier,
      );

  group('FavoriteCurrenciesBloc', () {
    blocTest<FavoriteCurrenciesBloc, FavoriteCurrenciesState>(
      'emits [Updating, UpdatedFavorites] when LoadFavorites is added and [IFavoriteCurrenicesRepository] does not throw any exception',
      setUp: () {
        when(favoriteCurrenicesRepository.getFavorites()).thenAnswer(
            (_) async => quotesLatestCurrencies.map((e) => e.symbol).toList());
        when(cryptoCurrencyRepository.getCryptoCurrencyBySymbols(any))
            .thenAnswer((_) async => quotesLatestCurrencies);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const FavoriteCurrenciesEvent.loadFavorites()),
      expect: () => <FavoriteCurrenciesState>[
        const FavoriteCurrenciesState.updating(),
        FavoriteCurrenciesState.updatedFavorites(
            KtList.from(quotesLatestCurrencies))
      ],
      verify: (bloc) {
        verify(favoriteCurrenicesRepository.getFavorites()).called(1);
        verify(cryptoCurrencyRepository.getCryptoCurrencyBySymbols(
                quotesLatestCurrencies.map((e) => e.symbol).toList()))
            .called(1);
        verifyNoMoreInteractions(favoriteCurrenicesRepository);
        verifyNoMoreInteractions(cryptoCurrencyRepository);
      },
    );

    blocTest<FavoriteCurrenciesBloc, FavoriteCurrenciesState>(
      'emits [Updating, Error] when LoadFavorites is added and any [IFavoriteCurrenicesRepository] throws an exception',
      setUp: () {
        when(favoriteCurrenicesRepository.getFavorites())
            .thenAnswer((_) async => throw ApiException(''));
        when(cryptoCurrencyRepository.getCryptoCurrencyBySymbols(any))
            .thenAnswer((_) async => throw ApiException(''));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const FavoriteCurrenciesEvent.loadFavorites()),
      expect: () => <FavoriteCurrenciesState>[
        const FavoriteCurrenciesState.updating(),
        const FavoriteCurrenciesState.error('Api exception occurred.')
      ],
      verify: (bloc) {
        verify(favoriteCurrenicesRepository.getFavorites()).called(1);

        verifyNoMoreInteractions(favoriteCurrenicesRepository);
        verifyNoMoreInteractions(cryptoCurrencyRepository);
      },
    );
  });

  late CryptoCurrency toBeMarkedAsFavorite;

  blocTest<FavoriteCurrenciesBloc, FavoriteCurrenciesState>(
    'emits [Updating, UpdatedFavorites] when MarkAsFavorite is added and [IFavoriteCurrenicesRepository, ICryptoCurrencyRepository] does not throw any exception',
    setUp: () {
      toBeMarkedAsFavorite = latestCurrencies[0];
      when(favoriteCurrenicesRepository.markCurrencyAsFavorite(any))
          .thenAnswer((_) async {});
      when(cryptoCurrencyRepository.getCryptoCurrencyBySymbols(any))
          .thenAnswer((invocation) async {
        final l = invocation.positionalArguments[0] as List;
        if (l.isEmpty) return [];
        return [toBeMarkedAsFavorite];
      });
      when(favoriteCurrenicesRepository.getFavorites())
          .thenAnswer((_) async => []);
    },
    build: buildBloc,
    act: (bloc) => bloc.add(
        FavoriteCurrenciesEvent.markAsFavorite(toBeMarkedAsFavorite.symbol)),
    expect: () => <FavoriteCurrenciesState>[
      const FavoriteCurrenciesState.updating(),
      FavoriteCurrenciesState.updatedFavorites(
          KtList.from([toBeMarkedAsFavorite]))
    ],
    verify: (bloc) {
      verify(favoriteCurrenicesRepository
              .markCurrencyAsFavorite(toBeMarkedAsFavorite.symbol))
          .called(1);
      verify(cryptoCurrencyRepository
              .getCryptoCurrencyBySymbols([toBeMarkedAsFavorite.symbol]))
          .called(greaterThanOrEqualTo(1));
      verify(favoriteCurrenciesNotifier.add(
          FavoriteCurrenciesNotifierEvent.markedCurrencyAsFavoriteSuccessfully(
              toBeMarkedAsFavorite.symbol)));
      verifyNoMoreInteractions(favoriteCurrenicesRepository);
      verifyNoMoreInteractions(cryptoCurrencyRepository);
    },
  );

  blocTest<FavoriteCurrenciesBloc, FavoriteCurrenciesState>(
    'When [LoadFavorites] is added and there are no favorites ( [IFavoriteCurrenicesRepository] returns empty list ) it should not call any apis',
    setUp: () {
      when(favoriteCurrenicesRepository.getFavorites())
          .thenAnswer((_) async => []);
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const FavoriteCurrenciesEvent.loadFavorites()),
    verify: (bloc) {
      verify(favoriteCurrenicesRepository.getFavorites()).called(1);
      verifyNoMoreInteractions(favoriteCurrenicesRepository);
      verifyNoMoreInteractions(cryptoCurrencyRepository);
    },
  );

  blocTest<FavoriteCurrenciesBloc, FavoriteCurrenciesState>(
    'emits [Updating, UpdatedFavorites] when MarkAsFavorite is added and [IFavoriteCurrenicesRepository] does throw an exception',
    setUp: () {
      toBeMarkedAsFavorite = latestCurrencies[0];
      when(favoriteCurrenicesRepository.markCurrencyAsFavorite(any))
          .thenAnswer((_) async {
        throw MarkedCurrencyAsFavoriteTwiceException();
      });
      when(cryptoCurrencyRepository.getCryptoCurrencyBySymbols(any))
          .thenAnswer((_) async => [toBeMarkedAsFavorite]);
      when(favoriteCurrenicesRepository.getFavorites())
          .thenAnswer((_) async => []);
    },
    build: buildBloc,
    act: (bloc) => bloc.add(
        FavoriteCurrenciesEvent.markAsFavorite(toBeMarkedAsFavorite.symbol)),
    expect: () => <FavoriteCurrenciesState>[
      const FavoriteCurrenciesState.updating(),
      FavoriteCurrenciesState.updatedFavorites(
          [toBeMarkedAsFavorite].toImmutableList()),
    ],
    verify: (bloc) {
      verify(favoriteCurrenicesRepository
              .markCurrencyAsFavorite(toBeMarkedAsFavorite.symbol))
          .called(1);
      verify(favoriteCurrenciesNotifier.add(
          FavoriteCurrenciesNotifierEvent.errorMarkingCurrencyAsFavorite(
              toBeMarkedAsFavorite.symbol)));
      verifyNoMoreInteractions(favoriteCurrenicesRepository);
      verifyNoMoreInteractions(cryptoCurrencyRepository);
    },
  );

  blocTest<FavoriteCurrenciesBloc, FavoriteCurrenciesState>(
    'emits [Updating, UpdatedFavorites] when MarkAsFavorite is added and [ICryptoCurrencyRepository] does throw an exception',
    setUp: () {
      toBeMarkedAsFavorite = latestCurrencies[0];
      when(favoriteCurrenicesRepository.markCurrencyAsFavorite(any))
          .thenAnswer((_) async {});
      when(cryptoCurrencyRepository.getCryptoCurrencyBySymbols(any))
          .thenAnswer((_) async {
        throw MarkedCurrencyAsFavoriteTwiceException();
      });
      when(favoriteCurrenicesRepository.getFavorites())
          .thenAnswer((_) async => []);
    },
    build: buildBloc,
    act: (bloc) => bloc.add(
        FavoriteCurrenciesEvent.markAsFavorite(toBeMarkedAsFavorite.symbol)),
    expect: () => <FavoriteCurrenciesState>[
      const FavoriteCurrenciesState.updating(),
      FavoriteCurrenciesState.updatedFavorites(
          [toBeMarkedAsFavorite].toImmutableList()),
    ],
    verify: (bloc) {
      verify(favoriteCurrenicesRepository
              .markCurrencyAsFavorite(toBeMarkedAsFavorite.symbol))
          .called(1);
      verify(cryptoCurrencyRepository
          .getCryptoCurrencyBySymbols([toBeMarkedAsFavorite.symbol])).called(1);
      verify(favoriteCurrenciesNotifier.add(
          FavoriteCurrenciesNotifierEvent.errorMarkingCurrencyAsFavorite(
              toBeMarkedAsFavorite.symbol)));
      verifyNoMoreInteractions(favoriteCurrenicesRepository);
      verifyNoMoreInteractions(cryptoCurrencyRepository);
    },
  );

  blocTest<FavoriteCurrenciesBloc, FavoriteCurrenciesState>(
    'emits [Updating, UpdatedFavorites] when [RemoveFromFavorites] is added and [IFavoriteCurrenciesRepository, ICryptoCurrencyRepository] does not throw any exception',
    setUp: () {
      toBeMarkedAsFavorite = latestCurrencies[0];
      when(favoriteCurrenicesRepository.getFavorites()).thenAnswer((_) async {
        return [];
      });
      when(cryptoCurrencyRepository.getCryptoCurrencyBySymbols(any))
          .thenAnswer((_) => Future.value([]));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(FavoriteCurrenciesEvent.removeFromFavorites(
        toBeMarkedAsFavorite.symbol)),
    expect: () => <FavoriteCurrenciesState>[
      const FavoriteCurrenciesState.updating(),
      const FavoriteCurrenciesState.updatedFavorites(KtList.empty())
    ],
    verify: (bloc) {
      verify(favoriteCurrenicesRepository
              .removeCurrencyFromFavorites(toBeMarkedAsFavorite.symbol))
          .called(1);
      verify(favoriteCurrenicesRepository.getFavorites()).called(1);
      verify(cryptoCurrencyRepository.getCryptoCurrencyBySymbols([])).called(1);
      verify(favoriteCurrenciesNotifier.add(FavoriteCurrenciesNotifierEvent
          .removedCurrencyFromFavoritesSuccessfully(
              toBeMarkedAsFavorite.symbol)));
      verifyNoMoreInteractions(favoriteCurrenicesRepository);
      verifyNoMoreInteractions(cryptoCurrencyRepository);
    },
  );

  blocTest<FavoriteCurrenciesBloc, FavoriteCurrenciesState>(
    'emits [Updating, UpdatedFavorites] when [RemoveFromFavorites] is added and [IFavoriteCurrenciesRepository] does throw an exception',
    setUp: () {
      toBeMarkedAsFavorite = latestCurrencies[0];
      when(favoriteCurrenicesRepository.getFavorites()).thenAnswer((_) async {
        throw Exception();
      });
    },
    build: buildBloc,
    act: (bloc) => bloc.add(FavoriteCurrenciesEvent.removeFromFavorites(
        toBeMarkedAsFavorite.symbol)),
    expect: () => <FavoriteCurrenciesState>[
      const FavoriteCurrenciesState.updating(),
      const FavoriteCurrenciesState.updatedFavorites(KtList.empty())
    ],
    verify: (bloc) {
      verify(favoriteCurrenicesRepository
              .removeCurrencyFromFavorites(toBeMarkedAsFavorite.symbol))
          .called(1);
      verify(favoriteCurrenicesRepository.getFavorites()).called(1);
      verify(favoriteCurrenciesNotifier.add(
          FavoriteCurrenciesNotifierEvent.errorRemovingCurrencyFromFavorites(
              toBeMarkedAsFavorite.symbol)));
      verifyNoMoreInteractions(favoriteCurrenicesRepository);
      verifyNoMoreInteractions(cryptoCurrencyRepository);
    },
  );

  blocTest<FavoriteCurrenciesBloc, FavoriteCurrenciesState>(
    'emits [Updating, UpdatedFavorites] when [RemoveFromFavorites] is added and [ICryptoCurrencyRepository] does throw an exception',
    setUp: () {
      toBeMarkedAsFavorite = latestCurrencies[0];
      when(favoriteCurrenicesRepository.getFavorites()).thenAnswer((_) async {
        return [];
      });
      when(cryptoCurrencyRepository.getCryptoCurrencyBySymbols(any))
          .thenAnswer((_) {
        throw Exception();
      });
    },
    build: buildBloc,
    act: (bloc) => bloc.add(FavoriteCurrenciesEvent.removeFromFavorites(
        toBeMarkedAsFavorite.symbol)),
    expect: () => <FavoriteCurrenciesState>[
      const FavoriteCurrenciesState.updating(),
      const FavoriteCurrenciesState.updatedFavorites(KtList.empty())
    ],
    verify: (bloc) {
      verify(favoriteCurrenicesRepository
              .removeCurrencyFromFavorites(toBeMarkedAsFavorite.symbol))
          .called(1);
      verify(favoriteCurrenicesRepository.getFavorites()).called(1);
      verify(cryptoCurrencyRepository.getCryptoCurrencyBySymbols([])).called(1);
      verify(favoriteCurrenciesNotifier.add(
          FavoriteCurrenciesNotifierEvent.errorRemovingCurrencyFromFavorites(
              toBeMarkedAsFavorite.symbol)));
      verifyNoMoreInteractions(favoriteCurrenicesRepository);
      verifyNoMoreInteractions(cryptoCurrencyRepository);
    },
  );
}

*/