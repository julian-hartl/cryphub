part of 'settings_notifier_bloc.dart';

@freezed
class SettingsNotifierState with _$SettingsNotifierState {
  const factory SettingsNotifierState.initial() = _Initial;
  const factory SettingsNotifierState.errorTogglingDarkMode() =
      _ErrorTogglingDarkMode;
  const factory SettingsNotifierState.toggledDarkMode(bool value) =
      _ToggledDarkMode;
}
