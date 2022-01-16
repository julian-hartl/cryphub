part of 'settings_notifier_bloc.dart';

@freezed
class SettingsNotifierEvent with _$SettingsNotifierEvent {
  const factory SettingsNotifierEvent.errorOccurredWhileTogglingDarkMode() =
      _ErrorOccurredWhileTogglingDarkMode;
  const factory SettingsNotifierEvent.successfullyToggledDarkMode(bool value) =
      _SuccessfullyToggledDarkMode;
}
