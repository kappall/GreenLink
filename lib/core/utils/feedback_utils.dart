import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
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

  /// Mostra un messaggio di successo in alto
  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
  }) {
    ElegantNotification.success(
      width: 360,
      position: Alignment.topCenter,
      animation: AnimationType.fromTop,
      title: Text(
        title ?? 'Ottimo!',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(message),
    ).show(context);
  }

  /// Mostra un messaggio di errore in alto, pulendo automaticamente il testo
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

    ElegantNotification.error(
      width: 360,
      position: Alignment.topCenter,
      animation: AnimationType.fromTop,
      title: Text(
        title ?? 'Ops!',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(message),
    ).show(context);
  }

  /// Mostra un messaggio informativo
  static void showInfo(BuildContext context, String message, {String? title}) {
    ElegantNotification.info(
      width: 360,
      position: Alignment.topCenter,
      animation: AnimationType.fromTop,
      title: Text(
        title ?? 'Info',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(message),
    ).show(context);
  }

  static void logDebug(dynamic message) => _logger.d(message.toString());
  static void logError(dynamic message) => _logger.e(message.toString());
  static void logInfo(dynamic message) => _logger.i(message.toString());
}
