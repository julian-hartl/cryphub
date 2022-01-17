import 'package:shared_preferences/shared_preferences.dart';

import 'settings.dart';

abstract class ISettingsRepository {
  /// Replaces the current settings with the new [settings].
  Future<void> updateSettings(Settings settings);

  /// Get the current settings.
  /// Make sure to initialize [SharedPreferences] before:
  /// ```dart
  /// final sp = await SharedPreferences.getInstance();
  /// ```
  Settings readSettings();
}
