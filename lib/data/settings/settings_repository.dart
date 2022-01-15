import 'package:cryphub/domain/settings/settings.dart';
import 'package:cryphub/domain/settings/settings_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SettingsRepository implements ISettingsRepository {
  @override
  Future<Settings> readSettings() {
    // TODO: implement readSettings
    throw UnimplementedError();
  }

  @override
  Future<void> updateSettings(Settings settings) {
    // TODO: implement updateSettings
    throw UnimplementedError();
  }
}
