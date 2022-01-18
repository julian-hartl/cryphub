import 'package:cryphub/core/app.dart';
import 'package:injectable/injectable.dart';

import 'configure_dependencies.config.dart';

@InjectableInit()
Future<void> configureDependencies() async {
  await $initGetIt(app);
}
