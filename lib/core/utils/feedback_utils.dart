import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FeedbackUtils {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 15,
      errorMethodCount: 18,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  static void _showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white),
                const SizedBox(width: 16),
              ],
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      );
  }

  /// Mostra un messaggio di successo con SnackBar
  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
  }) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle_outline,
    );
  }

  /// Mostra un messaggio di errore con SnackBar
  static void showError(
    BuildContext context,
    dynamic error, {
    StackTrace? stackTrace,
    String? title,
  }) {
    final String message = error
        .toString()
        .replaceAll('Exception: ', '')
        .replaceAll('Error: ', '')
        .trim();

    _showSnackBar(
      context,
      message,
      backgroundColor: Theme.of(context).colorScheme.error,
      icon: Icons.error_outline,
    );
  }

  /// Mostra un messaggio informativo con SnackBar
  static void showInfo(BuildContext context, String message, {String? title}) {
    _showSnackBar(context, message, icon: Icons.info_outline);
  }

  static void logDebug(dynamic message) => _logger.d(message.toString());
  static void logError(dynamic message) => _logger.e(message.toString());
  static void logInfo(dynamic message) => _logger.i(message.toString());
}
