part of 'settings_bloc.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.toggleDarkMode(bool value) = _ToggleDarkMode;
  const factory SettingsEvent.loadSettings() = _LoadSettings;
}
