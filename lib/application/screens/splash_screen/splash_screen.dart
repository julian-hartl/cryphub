import 'package:after_layout/after_layout.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../configure_dependencies.dart';
import '../../../domain/core/cache/cache.dart';
import '../../../domain/settings/settings_repository.dart';
import '../../../themes.dart';
import '../../app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin<SplashScreen> {
  @override
  void afterFirstLayout(BuildContext context) async {
    // await configureDependencies().then((value) async {
    //   final settings = await app.get<ISettingsRepository>().readSettings();
    //   ThemeProvider.controllerOf(context)
    //       .setTheme(settings.darkMode ? Themes.dark : Themes.light);
    // });
    Future.wait([
      GetStorage.init(),
      Cache.init(),
    ]).then((_) async {
      AutoRouter.of(context).navigate(const HomeScreenRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
