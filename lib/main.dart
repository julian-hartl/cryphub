import 'package:cryphub/core/configure_dependencies.dart';
import 'package:cryphub/core/error_handler.dart';

import 'core/cryphub.dart';

void main() async {
  await configureDependencies();
  ErrorHandler(child: Cryphub());
}
