import 'package:cryphub/application/blocs/favorite_currencies/favorite_currencies_bloc.dart';
import 'package:cryphub/application/blocs/favorite_currencies_notifier/favorite_currencies_notifier_bloc.dart';
import 'package:cryphub/application/blocs/latest_currencies/latest_currencies_bloc.dart';
import 'package:cryphub/application/blocs/settings/settings_bloc.dart';
import 'package:cryphub/application/blocs/settings_notifier/settings_notifier_bloc.dart';
import 'package:cryphub/application/blocs/splash_screen/splash_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';

class GlobalProvider extends StatelessWidget {
  const GlobalProvider({Key? key, required this.child}) : super(key: key);
  final Widget child;

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
        BlocProvider(
          create: (context) => app.get<SplashScreenBloc>(),
        ),
      ],
      child: child,
    );
  }
}
