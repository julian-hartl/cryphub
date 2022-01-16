import 'package:cryphub/application/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme_provider/theme_provider.dart';

import 'application/blocs/favorite_currencies/favorite_currencies_bloc.dart';
import 'application/blocs/favorite_currencies_notifier/favorite_currencies_notifier_bloc.dart';
import 'application/blocs/latest_currencies/latest_currencies_bloc.dart';
import 'application/blocs/settings/settings_bloc.dart';
import 'application/blocs/settings_notifier/settings_notifier_bloc.dart';
import 'configure_dependencies.dart';
import 'domain/settings/settings_repository.dart';
import 'themes.dart';

class Cryphub extends StatelessWidget {
  Cryphub({Key? key}) : super(key: key);

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => app.get<FavoriteCurrenciesBloc>()
            ..add(
              const FavoriteCurrenciesEvent.loadFavorites(),
            ),
        ),
        BlocProvider(
          create: (context) => app.get<LatestCurrenciesBloc>(),
        ),
        BlocProvider(
          create: (context) => app.get<FavoriteCurrenciesNotifierBloc>(),
        ),
        BlocProvider(
          create: (context) => app.get<SettingsBloc>(),
        ),
        BlocProvider(
          create: (context) => app.get<SettingsNotifierBloc>(),
        ),
      ],
      child: ThemeProvider(
        child: ThemeConsumer(
          child: Builder(
            builder: (context) => MaterialApp.router(
              title: 'Cryphub',
              theme: ThemeProvider.themeOf(context).data,
              routerDelegate: appRouter.delegate(),
              routeInformationParser: appRouter.defaultRouteParser(),
            ),
          ),
        ),
        themes: [
          AppTheme(id: 'dark', data: dark(context), description: 'Dark theme'),
          AppTheme(
              id: 'light', data: light(context), description: 'Light theme'),
        ],
        defaultThemeId: 'light',
      ),
    );
  }
}
