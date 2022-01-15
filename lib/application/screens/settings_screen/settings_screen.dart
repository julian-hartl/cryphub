import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                color: Theme.of(context).colorScheme.onBackground.withOpacity(
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
                    initial: false,
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
