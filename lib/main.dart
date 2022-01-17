import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'cryphub.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // https://stackoverflow.com/questions/50322054/flutter-how-to-set-and-lock-screen-orientation-on-demand
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(Cryphub());
}
