import 'package:cryphub/core/configure_dependencies.dart';
import 'package:cryphub/core/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import 'core/cryphub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kProfileMode) {
    // timeDilation = 5.0;
  }
  
  await configureDependencies();
  ErrorHandler(child: Cryphub());
}
