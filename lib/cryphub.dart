import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cryphub/application/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/blocs/favorite_currencies/favorite_currencies_bloc.dart';
import 'application/blocs/favorite_currencies_notifier/favorite_currencies_notifier_bloc.dart';
import 'application/blocs/latest_currencies/latest_currencies_bloc.dart';
import 'application/blocs/settings/settings_bloc.dart';
import 'application/blocs/settings_notifier/settings_notifier_bloc.dart';
import 'configure_dependencies.dart';
import 'themes.dart';

class Cryphub extends StatelessWidget {
  Cryphub({Key? key}) : super(key: key);

  final appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      builder: (light, dark) => MultiBlocProvider(
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
        child: MaterialApp.router(
          theme: light,
          darkTheme: dark,
          title: 'Cryphub',
          routerDelegate: appRouter.delegate(),
          routeInformationParser: appRouter.defaultRouteParser(),
        ),
      ),
      initial: AdaptiveThemeMode.light,
      light: light(context),
      dark: dark(context),
    );
  }
}
