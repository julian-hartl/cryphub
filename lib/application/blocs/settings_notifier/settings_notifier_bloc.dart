import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'settings_notifier_event.dart';
part 'settings_notifier_state.dart';
part 'settings_notifier_bloc.freezed.dart';

@lazySingleton
class SettingsNotifierBloc
    extends Bloc<SettingsNotifierEvent, SettingsNotifierState> {
  SettingsNotifierBloc() : super(const SettingsNotifierState.initial()) {
    on<_ErrorOccurredWhileTogglingDarkMode>((event, emit) {
      emit(const SettingsNotifierState.errorTogglingDarkMode());
    });
    on<_SuccessfullyToggledDarkMode>((event, emit) {
      emit(SettingsNotifierState.toggledDarkMode(event.value));
    });
  }
}
