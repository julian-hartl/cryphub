import 'package:bloc/bloc.dart';
import '../settings_notifier/settings_notifier_bloc.dart';
import '../../../domain/core/logger/logger.dart';
import '../../../domain/settings/settings.dart';
import '../../../domain/settings/settings_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'settings_event.dart';
part 'settings_state.dart';
part 'settings_bloc.freezed.dart';

@lazySingleton
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ISettingsRepository settingsRepository;
  final SettingsNotifierBloc settingsNotifierBloc;
  final Logger logger;

  SettingsBloc(
    this.settingsRepository,
    this.settingsNotifierBloc,
    this.logger,
  ) : super(const SettingsState.loadingSettings()) {
    on<_ToggleDarkMode>((event, emit) async {
      try {
        final currentSettings = settingsRepository.readSettings();
        final updatedSettings = currentSettings.copyWith(darkMode: event.value);
        await settingsRepository.updateSettings(updatedSettings);
        settingsNotifierBloc.add(
            SettingsNotifierEvent.successfullyToggledDarkMode(event.value));
        emit(SettingsState.loadedSettings(updatedSettings));
      } catch (_) {
        settingsNotifierBloc.add(
            const SettingsNotifierEvent.errorOccurredWhileTogglingDarkMode());
      }
    });

    on<_LoadSettings>((event, emit) async {
      emit(const SettingsState.loadingSettings());
      try {
        final settings = settingsRepository.readSettings();
        emit(SettingsState.loadedSettings(settings));
      } catch (_) {
        emit(const SettingsState.error('Could not load settings...'));
      }
    });
  }
}
