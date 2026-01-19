import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/event/models/ticket_validation_result.dart';
import 'package:http/http.dart' as http;

final eventTicketServiceProvider = Provider<EventTicketService>(
  (ref) => EventTicketService(),
);

class EventTicketService {
  final String _baseUrl = 'https://greenlink.tommasodeste.it/api';

  Future<String> participate({required String eventId, String? token}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/event/$eventId'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          final direct = decoded['ticket'] ?? decoded['code'];
          if (direct != null) return direct.toString();

          final event = decoded['event'];
          if (event is Map) {
            final nested = event['ticket'] ?? event['code'];
            if (nested != null) return nested.toString();
          }

          final data = decoded['data'];
          if (data is Map) {
            final nested = data['ticket'] ?? data['code'];
            if (nested != null) return nested.toString();
            final eventData = data['event'];
            if (eventData is Map) {
              final nestedEvent = eventData['ticket'] ?? eventData['code'];
              if (nestedEvent != null) return nestedEvent.toString();
            }
          }
          if (data is String) return data;
        }
      } catch (e) {
        throw Exception('Failed to parse server response.');
      }
    }

    throw Exception('Failed to fetch event ticket.');
  }

  Future<TicketValidationResult> checkTicket({
    required String eventId,
    required String ticket,
    String? token,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/event/$eventId/check'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'ticket': ticket}),
    );

    if (response.statusCode == 200) {
      return TicketValidationResult.valid();
    } else {
      dynamic data;
      try {
        data = json.decode(response.body);
      } catch (e) {
        return const TicketValidationResult.error(
          message: 'Invalid response format.',
        );
      }
      final message = data['error'];
      switch (message) {
        case 'invalid ticket for this event':
          return const TicketValidationResult.wrongEvent();
        default:
          return TicketValidationResult.error(message: 'Biglietto non valido');
      }
    }
  }
}
