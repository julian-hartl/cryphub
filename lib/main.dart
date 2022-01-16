import 'package:cryphub/domain/core/cache/cache.dart';

import 'configure_dependencies.dart';
import 'cryphub.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // https://stackoverflow.com/questions/50322054/flutter-how-to-set-and-lock-screen-orientation-on-demand
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(Cryphub());
}
