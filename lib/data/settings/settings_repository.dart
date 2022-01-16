import 'dart:convert';

import 'package:cryphub/domain/core/logger/logger.dart';
import 'package:cryphub/domain/settings/settings.dart';
import 'package:cryphub/domain/settings/settings_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: ISettingsRepository)
class SettingsRepository implements ISettingsRepository {
  final SharedPreferences sharedPreferences;
  final Logger logger;

  SettingsRepository(
    this.sharedPreferences,
    this.logger,
  );

  Settings? _settings;

  @override
  Future<Settings> readSettings() async {
    if (_settings != null) {
      return _settings!;
    }
    final settingsJson = sharedPreferences.getString('settings');
    if (settingsJson == null) {
      final defaultSettings = Settings.defaultSettings();
      await updateSettings(defaultSettings);
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
