part of 'settings_bloc.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.loadingSettings() = _LoadingSettings;
  const factory SettingsState.loadedSettings(Settings settings) =
      _LoadedSettings;
  const factory SettingsState.error(String message) = _Error;
}
