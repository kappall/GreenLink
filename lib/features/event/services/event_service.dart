import 'dart:convert';

import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:http/http.dart' as http;

class EventService {
  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';

  Future<List<EventModel>> fetchAllEvents({required String? token}) {
    final uri = Uri.parse('$_baseUrl/events');
    return _requestEvents(uri: uri, token: token);
  }

  Future<List<EventModel>> fetchEvents({
    required String token,
    int? partnerId,
  }) async {
    final uri = Uri.parse('$_baseUrl/events').replace(
      queryParameters: {
        if (partnerId != null && partnerId > 0) 'partner': partnerId.toString(),
      },
    );

    return _requestEvents(uri: uri, token: token);
  }

  Future<List<EventModel>> _requestEvents({
    required Uri uri,
    required String? token,
  }) async {
    final headers = {'Accept': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      throw Exception('Errore durante il recupero degli eventi: $message');
    }

    final decoded = jsonDecode(response.body);
    final dynamic rawList = switch (decoded) {
      final Map<String, dynamic> map => map['events'] ?? map['data'] ?? map,
      final List<dynamic> list => list,
      _ => decoded,
    };
    if (rawList is! List) {
      throw Exception('Risposta inattesa da /events: $rawList');
    }
    return rawList
        .whereType<Map<String, dynamic>>()
        .map(EventModel.fromJson)
        .toList();
  }

  Future<EventModel> createEvent({
    required String token,
    required String description,
    required double latitude,
    required double longitude,
    required EventType eventType,
    required int maxParticipants,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/event'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'event_type': eventType.name,
        'max_participants': maxParticipants,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      throw Exception('Errore durante la creazione dell\'evento: $message');
    }

    final decoded = jsonDecode(response.body);
    final rawEvent = decoded is Map<String, dynamic>
        ? decoded['event'] ?? decoded
        : decoded;
    if (rawEvent is! Map<String, dynamic>) {
      throw Exception(
        'Risposta inattesa dalla creazione evento: ${response.body}',
      );
    }

    return EventModel.fromJson(rawEvent);
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
