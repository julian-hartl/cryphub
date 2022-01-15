import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cryphub/application/app_router.dart';
import 'package:flutter/material.dart';

import 'themes.dart';

class Cryphub extends StatelessWidget {
  Cryphub({Key? key}) : super(key: key);

  final appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      builder: (light, dark) => MaterialApp.router(
        theme: light,
        darkTheme: dark,
        title: 'Cryphub',
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),
      ),
      initial: AdaptiveThemeMode.light,
      light: light(context),
      dark: dark(context),
    );
  }
}
