import 'package:cryphub/core/configure_dependencies.dart';
import 'package:cryphub/core/error_handler.dart';
import 'package:flutter/material.dart';

import 'core/cryphub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  ErrorHandler(child: Cryphub());
}
