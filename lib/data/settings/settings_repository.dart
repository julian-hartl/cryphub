import 'dart:convert';

import 'package:cryphub/data/logger/logger_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/settings/settings.dart';
import '../../domain/settings/settings_repository.dart';

@LazySingleton(as: ISettingsRepository)
class SettingsRepository with LoggerProvider implements ISettingsRepository {
  final SharedPreferences sharedPreferences;

  SettingsRepository(
    this.sharedPreferences,
  );

  Settings? _settings;

  @override
  Settings readSettings() {
    if (_settings != null) {
      return _settings!;
    }
    final settingsJson = sharedPreferences.getString('settings');
    if (settingsJson == null) {
      final defaultSettings = Settings.defaultSettings();
      updateSettings(defaultSettings);
      _settings = defaultSettings;
      return defaultSettings;
    }
    final json = jsonDecode(settingsJson);
    final settings = Settings.fromJson(json);
    _settings = settings;
    return _settings!;
  }

  @override
  Future<void> updateSettings(Settings settings) async {
    _settings = settings;
    final json = jsonEncode(settings.toJson());
    await sharedPreferences.setString('settings', json);
  }
}
