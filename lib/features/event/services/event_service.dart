import 'dart:convert';

import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:http/http.dart' as http;

class EventService {
  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';

  Future<List<EventModel>> fetchEvents({
    required String token,
    int? partnerId,
  }) async {
    final uri = Uri.parse('$_baseUrl/events').replace(
      queryParameters: {
        if (partnerId != null && partnerId > 0) 'partner': partnerId.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      throw Exception('Errore durante il recupero degli eventi: $message');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final dynamic rawList = decoded['events'] ?? decoded['data'] ?? decoded;
    if (rawList is! List) {
      throw Exception('Risposta inattesa da /events: $rawList');
    }

    return rawList
        .whereType<Map<String, dynamic>>()
        .map(EventModel.fromJson)
        .toList();
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
