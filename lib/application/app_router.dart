import 'package:auto_route/auto_route.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/settings_screen/settings_screen.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  routes: [
    CustomRoute(
      page: SplashScreen,
      initial: true,
    ),
    CustomRoute(
      page: HomeScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 200,
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
