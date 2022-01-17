part of 'splash_screen_bloc.dart';

@freezed
class SplashScreenEvent with _$SplashScreenEvent {
  const factory SplashScreenEvent.initialize() = _Initialize;
  const factory SplashScreenEvent.recheckNetwork() = _RecheckNetwork;
}
