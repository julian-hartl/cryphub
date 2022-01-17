import 'package:bloc/bloc.dart';
import '../../../domain/core/logger/logger.dart';
import '../../../data/crypto_currency/crypto_currency_repository.dart';
import '../../../domain/crypto_currency/crypto_currency.dart';
import '../../../domain/crypto_currency/crypto_currency_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';

part 'latest_currencies_event.dart';
part 'latest_currencies_state.dart';
part 'latest_currencies_bloc.freezed.dart';

@lazySingleton
class LatestCurrenciesBloc
    extends Bloc<LatestCurrenciesEvent, LatestCurrenciesState> {
  final ICryptoCurrencyRepository cryptoCurrencyRepository;
  final Logger logger;

  static const int pageSize = 20;

  LatestCurrenciesBloc(
    this.cryptoCurrencyRepository,
    this.logger,
  ) : super(const LatestCurrenciesState.loading()) {
    on<_LoadNextPage>((event, emit) async {
      emit(const LatestCurrenciesState.loading());
      try {
        // repository starts counting at 1 while ui does at 0
        final page = event.page + 1;
        final latest = await cryptoCurrencyRepository.getLatest(page, pageSize);
        emit(LatestCurrenciesState.loadingSuccess(
            KtList.from(latest), page - 1));
      } catch (e) {
        logger.warning(e);

        emit(const LatestCurrenciesState.error('Api exception occurred.'));
      }
    });
  }
}
