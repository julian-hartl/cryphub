import 'data/crypto_currency/crypto_currency_cache.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'configure_dependencies.config.dart';

final app = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  app.registerLazySingleton<CryptoCurrencyCache>(() => CryptoCurrencyCache());
  $initGetIt(app);
}