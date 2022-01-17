import 'package:auto_route/auto_route.dart';
import 'package:cryphub/application/blocs/splash_screen/splash_screen_bloc.dart';
import 'package:cryphub/application/widgets/retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    context.read<SplashScreenBloc>().add(const SplashScreenEvent.initialize());
    return BlocConsumer<SplashScreenBloc, SplashScreenState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          initializationSuccess: () {
            AutoRouter.of(context).navigate(const HomeScreenRoute());
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: state.maybeWhen(
              orElse: () => const CircularProgressIndicator(),
              noConnection: () => Retry(
                'Please check your connection.',
                onRetry: () {
                  context
                      .read<SplashScreenBloc>()
                      .add(const SplashScreenEvent.recheckNetwork());
                },
              ),
              errorOccurred: () => Retry(
                'Unknown error occurred.',
                onRetry: () {
                  context
                      .read<SplashScreenBloc>()
                      .add(const SplashScreenEvent.initialize());
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
