import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ErrorAlert extends StatelessWidget {
  const ErrorAlert({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context, String message) async {
    showTopSnackBar(context, CustomSnackBar.error(message: message));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SuccessAlert extends StatelessWidget {
  const SuccessAlert({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context, String message) async {
    showTopSnackBar(context, CustomSnackBar.success(message: message));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
