import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cryphub/application/blocs/settings/settings_bloc.dart';
import 'package:cryphub/application/blocs/settings_notifier/settings_notifier_bloc.dart';
import 'package:cryphub/application/widgets/alerts.dart';
import 'package:cryphub/application/widgets/retry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<SettingsBloc>().add(const SettingsEvent.loadSettings());
    return const Scaffold(
      body: SettingsScreenContent(),
    );
  }
}

class SettingsScreenContent extends StatelessWidget {
  const SettingsScreenContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsNotifierBloc, SettingsNotifierState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          toggledDarkMode: (value) {
            AdaptiveTheme.of(context).setThemeMode(
                value ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light);
          },
          errorTogglingDarkMode: () {
            ErrorAlert.show(context, 'Could not toggle dark mode...');
          },
        );
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return state.when(
            loadingSettings: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loadedSettings: (settings) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AutoRouter.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                        ),
                      ),
                      const Gap(30),
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                        ),
                      ),
                      const Gap(50),
                      Text(
                        'Preferences'.toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(
                                0.6,
                              ),
                          letterSpacing: 1.5,
                          fontSize: 17,
                        ),
                      ),
                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Icon(Icons.brightness_2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                padding: const EdgeInsets.all(10.0),
                              ),
                              const Gap(10),
                              Text('Dark Mode'),
                            ],
                          ),
                          OnOffSwitch(
                              initial: settings.darkMode,
                              onChanged: (value) {
                                if (value) {
                                  AdaptiveTheme.of(context).setDark();
                                } else {
                                  AdaptiveTheme.of(context).setLight();
                                }
                              })
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            error: (message) {
              return Center(
                child: Retry(
                  message,
                  onRetry: () {
                    context
                        .read<SettingsBloc>()
                        .add(const SettingsEvent.loadSettings());
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class OnOffSwitch extends StatefulWidget {
  const OnOffSwitch({
    Key? key,
    this.onChanged,
    required this.initial,
  }) : super(key: key);

  final void Function(bool value)? onChanged;
  final bool initial;

  @override
  State<OnOffSwitch> createState() => _OnOffSwitchState();
}

class _OnOffSwitchState extends State<OnOffSwitch> {
  @override
  void initState() {
    off = !widget.initial;
    super.initState();
  }

  late bool off;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(off ? 'off' : 'on'),
        const Gap(5),
        CupertinoSwitch(
          value: !off,
          onChanged: (value) {
            setState(() {
              off = !value;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
        ),
      ],
    );
  }
}
