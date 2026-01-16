import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/core/utils/feedback_utils.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/event/models/ticket_validation_result.dart';
import 'package:http/http.dart' as http;

final eventTicketServiceProvider = Provider<EventTicketService>((ref) {
  final token = ref.watch(authProvider).asData?.value.token ?? '';
  return EventTicketService(token: token);
});

class EventTicketService {
  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';
  final String token;

  EventTicketService({this.token = ''});

  Future<String> participate({required String eventId}) async {
    final safeEventId = Uri.encodeComponent(eventId);
    final uri = Uri.parse('$_baseUrl/event/$safeEventId/participation');

    try {
      final response = await http.post(uri, headers: _headers());

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = _errorMessage(response);
        FeedbackUtils.logError(
          "POST $uri failed (${response.statusCode}): $message",
        );
        throw Exception(
          'Non è stato possibile generare il ticket. Riprova più tardi.',
        );
      }

      final ticket = _extractTicket(response.body);
      if (ticket.isEmpty) {
        FeedbackUtils.logError(
          'Ticket mancante nella risposta: ${response.body}',
        );
        throw Exception('Ticket non valido nella risposta del server.');
      }

      return ticket;
    } catch (e) {
      if (e is Exception) rethrow;
      FeedbackUtils.logError('Errore durante participate: $e');
      throw Exception('Errore durante la generazione del ticket.');
    }
  }

  Future<TicketValidationResult> checkTicket({
    required String eventId,
    required String ticket,
  }) async {
    final safeEventId = Uri.encodeComponent(eventId);
    final uri = Uri.parse('$_baseUrl/event/$safeEventId/check');

    try {
      final response = await http.post(
        uri,
        headers: _headers(isJson: true),
        body: jsonEncode({'ticket': ticket}),
      );

      return _parseValidationResponse(response);
    } catch (e) {
      FeedbackUtils.logError('Errore durante checkTicket: $e');
      return const TicketValidationResult.error(
        message: 'Errore di connessione. Riprova più tardi.',
      );
    }
  }

  Map<String, String> _headers({bool isJson = false}) {
    final headers = {'Accept': 'application/json'};
    if (isJson) {
      headers['Content-Type'] = 'application/json';
    }
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  TicketValidationResult _parseValidationResponse(http.Response response) {
    final decoded = _tryDecode(response.body);
    final parsed = _mapValidationResult(decoded);
    if (parsed != null) {
      return parsed;
    }

    final statusFallback = _mapStatusCode(response.statusCode);
    if (statusFallback != null) {
      return statusFallback;
    }

    final message = _errorMessage(response);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      FeedbackUtils.logError(
        'Risposta inattesa dalla validazione: ${response.body}',
      );
      return TicketValidationResult.error(
        message: message.isNotEmpty
            ? message
            : 'Risposta non valida dal server.',
      );
    }

    return TicketValidationResult.error(
      message: message.isNotEmpty
          ? message
          : 'Errore durante la validazione del ticket.',
    );
  }

  TicketValidationResult? _mapValidationResult(dynamic decoded) {
    if (decoded is bool) {
      return decoded
          ? const TicketValidationResult.valid()
          : const TicketValidationResult.error();
    }

    if (decoded is String) {
      return _resultFromString(decoded);
    }

    if (decoded is Map) {
      final bool? valid =
          _readBool(decoded, const ['valid', 'is_valid', 'isValid']);
      if (valid == true) {
        return const TicketValidationResult.valid();
      }
      if (valid == false) {
        final reason = _readString(
          decoded,
          const ['reason', 'error', 'message', 'result', 'status', 'code'],
        );
        return _resultFromString(reason ?? '') ??
            TicketValidationResult.error(message: reason);
      }

      final status = _readString(
        decoded,
        const ['result', 'status', 'outcome', 'code', 'message'],
      );
      if (status != null) {
        return _resultFromString(status) ??
            TicketValidationResult.error(message: status);
      }
    }

    return null;
  }

  TicketValidationResult? _mapStatusCode(int statusCode) {
    switch (statusCode) {
      case 409:
        return const TicketValidationResult.alreadyUsed();
      case 410:
        return const TicketValidationResult.expired();
      case 404:
        return const TicketValidationResult.wrongEvent();
      default:
        return null;
    }
  }

  TicketValidationResult? _resultFromString(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final normalized = trimmed.toLowerCase();
    final compact = normalized.replaceAll(RegExp(r'[^a-z]'), '');

    if (normalized.contains('already_used') ||
        normalized.contains('already used') ||
        normalized.contains('alreadyused') ||
        normalized.contains('used_ticket') ||
        compact.contains('alreadyused')) {
      return const TicketValidationResult.alreadyUsed();
    }

    if (normalized.contains('expired') || normalized.contains('scadut')) {
      return const TicketValidationResult.expired();
    }

    if (normalized.contains('wrong_event') ||
        normalized.contains('wrong event') ||
        normalized.contains('event_mismatch') ||
        normalized.contains('not_for_event') ||
        (normalized.contains('wrong') && normalized.contains('event')) ||
        compact.contains('wrongevent')) {
      return const TicketValidationResult.wrongEvent();
    }

    if (normalized.contains('invalid') ||
        normalized.contains('not valid') ||
        normalized.contains('error') ||
        normalized.contains('failed') ||
        normalized.contains('non valido') ||
        normalized.contains('nonvalido')) {
      return TicketValidationResult.error(message: trimmed);
    }

    if (compact == 'valid' ||
        compact == 'ok' ||
        compact == 'success' ||
        (normalized.contains('valido') &&
            !normalized.contains('non valido') &&
            !normalized.contains('nonvalido'))) {
      return const TicketValidationResult.valid();
    }

    return null;
  }

  bool? _readBool(Map data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is bool) {
        return value;
      }
      if (value is String) {
        final normalized = value.toLowerCase().trim();
        if (normalized == 'true') return true;
        if (normalized == 'false') return false;
      }
      if (value is num) {
        if (value == 1) return true;
        if (value == 0) return false;
      }
    }
    return null;
  }

  String? _readString(Map data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String) {
        return value;
      }
    }
    return null;
  }

  String _extractTicket(String body) {
    final decoded = _tryDecode(body);

    if (decoded is String) {
      return decoded.trim();
    }

    if (decoded is Map) {
      final value = decoded['ticket'] ?? decoded['data'] ?? decoded['code'];
      if (value != null) {
        return value.toString().trim();
      }
    }

    return body.trim();
  }

  dynamic _tryDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  String _errorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['message']?.toString() ?? response.body;
    } catch (_) {
      return response.body;
    }
  }
}
