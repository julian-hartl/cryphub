import 'package:cryphub/application/blocs/latest_currencies/latest_currencies_bloc.dart';
import 'package:cryphub/domain/core/api_exception.dart';
import 'package:cryphub/domain/crypto_currency/crypto_currency_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../helpers/data_sets.dart';

/*
void main() {
  late MockICryptoCurrencyRepository cryptoCurrencyRepository;
  setUp(() {
    cryptoCurrencyRepository = MockICryptoCurrencyRepository();
  });
  group('LatestCurrenciesBloc', () {
    late int page;
    blocTest<LatestCurrenciesBloc, LatestCurrenciesState>(
      'Emit LoadingSuccess with currencies provided by repository',
      setUp: () {
        when(cryptoCurrencyRepository.getLatest(any, any))
            .thenAnswer((_) async => fakeCryptoCurrencies);
        page = 0;
      },
      build: () => LatestCurrenciesBloc(cryptoCurrencyRepository),
      act: (bloc) => bloc.add(LatestCurrenciesEvent.loadPage(page)),
      expect: () => <LatestCurrenciesState>[
        const LatestCurrenciesState.loading(),
        LatestCurrenciesState.loadingSuccess(
            KtList.from(fakeCryptoCurrencies), page)
      ],
      verify: (bloc) {
        verify(cryptoCurrencyRepository.getLatest(
                page + 1, LatestCurrenciesBloc.pageSize))
            .called(1);
      },
    );

    blocTest<LatestCurrenciesBloc, LatestCurrenciesState>(
      'Emit Error when repository throws an exception',
      setUp: () {
        when(cryptoCurrencyRepository.getLatest(any, any))
            .thenAnswer((_) async {
          throw ApiException('This is an error message');
        });
        page = 0;
      },
      build: () => LatestCurrenciesBloc(cryptoCurrencyRepository),
      act: (bloc) => bloc.add(LatestCurrenciesEvent.loadPage(page)),
      expect: () => <LatestCurrenciesState>[
        const LatestCurrenciesState.loading(),
        const LatestCurrenciesState.error('Api exception occurred.')
      ],
      verify: (bloc) {
        verify(cryptoCurrencyRepository.getLatest(
                page + 1, LatestCurrenciesBloc.pageSize))
            .called(1);
      },
    );
  });
}
*/