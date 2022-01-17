part of 'splash_screen_bloc.dart';

@freezed
class SplashScreenState with _$SplashScreenState {
  const factory SplashScreenState.initial() = _Initial;
  const factory SplashScreenState.initializationSuccess() =
      _InitializationSuccess;
  const factory SplashScreenState.noConnection() = _NoConnection;
  const factory SplashScreenState.errorOccurred() = _ErrorOccurred;
}
