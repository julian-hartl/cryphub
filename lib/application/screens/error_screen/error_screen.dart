import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    Key? key,
    required this.details,
  }) : super(key: key);

  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Oops, something went\nterribly wrong...',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const Gap(10),
            ElevatedButton(
              onPressed: () {
                FlutterError.presentError(details);
                exit(1);
              },
              child: const Text('Close & send report'),
            ),
            ElevatedButton(
              onPressed: () {
                exit(1);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
