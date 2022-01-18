import 'package:cryphub/core/global_provider.dart';
import 'package:cryphub/core/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import '../application/app_router.dart';

class Cryphub extends StatelessWidget {
  Cryphub({Key? key}) : super(key: key);

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return GlobalProvider(
      child: ThemeManager(
        child: Builder(builder: (context) {
          return MaterialApp.router(
            title: 'Cryphub',
            theme: ThemeProvider.themeOf(context).data,
            routerDelegate: appRouter.delegate(),
            routeInformationParser: appRouter.defaultRouteParser(),
            debugShowCheckedModeBanner: false,
          );
        }),
      ),
    );
  }
}
