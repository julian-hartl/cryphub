import 'domain/application_directories.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import 'data/crypto_currency/crypto_currency_cache.dart';

@module
abstract class PreDefinedApplicationStates {
  @lazySingleton
  CryptoCurrencyCache cryptoCurrencyCache() => CryptoCurrencyCache();

  @preResolve
  Future<ApplicationDirectories> applicationDirectories() async {
    final tempDir = await getTemporaryDirectory();
    final docDir = await getApplicationDocumentsDirectory();
    return ApplicationDirectories(tempDir: tempDir.path, docDir: docDir.path);
  }
}
