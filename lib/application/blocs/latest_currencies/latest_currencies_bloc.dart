import 'package:bloc/bloc.dart';
import 'package:cryphub/data/logger/logger_provider.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';

import '../../../domain/crypto_currency/crypto_currency.dart';
import '../../../domain/crypto_currency/crypto_currency_repository.dart';

part 'latest_currencies_bloc.freezed.dart';
part 'latest_currencies_event.dart';
part 'latest_currencies_state.dart';

@lazySingleton
class LatestCurrenciesBloc
    extends Bloc<LatestCurrenciesEvent, LatestCurrenciesState>
    with LoggerProvider {
  final ICryptoCurrencyRepository cryptoCurrencyRepository;

  static const int pageSize = 20;

  LatestCurrenciesBloc(
    this.cryptoCurrencyRepository,
  ) : super(const LatestCurrenciesState.loading()) {
    on<_LoadNextPage>((event, emit) async {
      emit(const LatestCurrenciesState.loading());
      try {
        // repository starts counting at 1 while ui does at 0
        final page = event.page + 1;
        final latest = await cryptoCurrencyRepository.getLatest(page, pageSize);
        emit(LatestCurrenciesState.loadingSuccess(
            KtList.from(latest), page - 1));
      } catch (e, st) {
        logger.error('', e, st);

        emit(const LatestCurrenciesState.error('Api exception occurred.'));
      }
    });
  }
}
