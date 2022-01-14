part of 'latest_currencies_bloc.dart';

@freezed
class LatestCurrenciesState with _$LatestCurrenciesState {
  const factory LatestCurrenciesState.loadingSuccess(
      KtList<CryptoCurrency> latest, int page) = _LoadingSuccess;
  const factory LatestCurrenciesState.loading() = _Loading;
  const factory LatestCurrenciesState.error(String message) = _Error;
}
