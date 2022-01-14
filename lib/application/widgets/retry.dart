import 'package:flutter/material.dart';

class Retry extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const Retry(
    this.errorMessage, {
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(errorMessage),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        )
      ],
    );
  }
}
