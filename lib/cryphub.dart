import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import 'application/screens/home_screen/home_screen.dart';
import 'themes.dart';

class Cryphub extends StatelessWidget {
  const Cryphub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      builder: (light, dark) => MaterialApp(
        theme: light,
        darkTheme: dark,
        title: 'Cryphub',
        home: const HomeScreen(),
      ),
      initial: AdaptiveThemeMode.light,
      light: light(context),
      dark: dark(context),
    );
  }
}
