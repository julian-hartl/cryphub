part of 'latest_currencies_bloc.dart';

@freezed
class LatestCurrenciesEvent with _$LatestCurrenciesEvent {
  const factory LatestCurrenciesEvent.loadPage(int page) = _LoadNextPage;
}
