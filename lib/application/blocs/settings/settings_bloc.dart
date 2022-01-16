import 'package:bloc/bloc.dart';
import 'package:cryphub/application/blocs/settings_notifier/settings_notifier_bloc.dart';
import 'package:cryphub/domain/core/logger/logger.dart';
import 'package:cryphub/domain/settings/settings.dart';
import 'package:cryphub/domain/settings/settings_repository.dart';
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
        final currentSettings = await settingsRepository.readSettings();

        await settingsRepository.updateSettings(
          currentSettings.copyWith(darkMode: event.value),
        );
        settingsNotifierBloc.add(
            SettingsNotifierEvent.successfullyToggledDarkMode(event.value));
      } catch (_) {
        settingsNotifierBloc.add(
            const SettingsNotifierEvent.errorOccurredWhileTogglingDarkMode());
      }
    });

    on<_LoadSettings>((event, emit) async {
      emit(const SettingsState.loadingSettings());
      try {
        final settings = await settingsRepository.readSettings();
        logger.info(settings);
        emit(SettingsState.loadedSettings(settings));
      } catch (_) {
        emit(const SettingsState.error('Could not load settings...'));
      }
    });
  }
}
