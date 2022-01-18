import 'package:cryphub/application/themes.dart';
import 'package:cryphub/domain/settings/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import 'app.dart';

class ThemeManager extends StatelessWidget {
  const ThemeManager({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      child: ThemeConsumer(
        child: child,
      ),
      themes: [
        AppTheme(
          id: Themes.dark,
          data: dark(context),
          description: 'Dark theme',
        ),
        AppTheme(
          id: Themes.light,
          data: light(context),
          description: 'Light theme',
        ),
      ],
      defaultThemeId: app.get<ISettingsRepository>().readSettings().darkMode
          ? Themes.dark
          : Themes.light,
      saveThemesOnChange: false,
    );
  }
}
