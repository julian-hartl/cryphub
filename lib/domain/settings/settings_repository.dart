import 'settings.dart';

abstract class ISettingsRepository {
  Future<void> updateSettings(Settings settings);
  Future<Settings> readSettings();
}
