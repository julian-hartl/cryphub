import 'package:auto_route/auto_route.dart';
import 'package:cryphub/application/screens/home_screen/home_screen.dart';
import 'package:cryphub/application/screens/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  routes: [
    CustomRoute(
      page: HomeScreen,
      initial: true,
    ),
    CustomRoute(
      page: SettingsScreen,
      transitionsBuilder: TransitionsBuilders.slideBottom,
      durationInMilliseconds: 200,
    ),
  ],
  replaceInRouteName: 'Page',
)
class AppRouter extends _$AppRouter {}
