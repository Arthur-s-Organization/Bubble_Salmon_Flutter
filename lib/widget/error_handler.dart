import 'package:flutter/material.dart';

class ErrorHandler {
  static void showError(BuildContext context, {String? customMessage}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            customMessage ?? "Une erreur est survenue. Veuillez réessayer."),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
