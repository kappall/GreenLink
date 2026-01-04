import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';

class FeedbackUtils {
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
  static void showError(BuildContext context, dynamic error, {String? title}) {
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
}
