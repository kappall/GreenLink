import 'dart:convert';

import 'package:greenlinkapp/core/utils/feedback_utils.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:http/http.dart' as http;

class EventService {
  EventService._();
  static final EventService instance = EventService._();

  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';
  final Map<String, List<EventModel>> _cache = {};

  void _clearCache() {
    _cache.clear();
  }

  Future<List<EventModel>> fetchAllEvents({
    required String? token,
    int? skip,
    int? limit,
  }) async {
    final uri = Uri.parse('$_baseUrl/events').replace(
      queryParameters: {
        'skip': skip?.toString() ?? '0',
        'limit': limit?.toString() ?? '20',
      },
    );

    return _requestEvents(uri: uri, token: token);
  }

  Future<List<EventModel>> fetchEventsByDistance({
    required String? token,
    required double latitude,
    required double longitude,
    int? skip,
    int? limit,
  }) {
    final uri = Uri.parse('$_baseUrl/events').replace(
      queryParameters: {
        'sort': 'distance',
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'skip': skip?.toString() ?? '0',
        'limit': limit?.toString() ?? '20',
      },
    );

    return _requestEvents(uri: uri, token: token);
  }

  Future<List<EventModel>> fetchEventsByUserId({
    required String? token,
    required int userId,
  }) {
    final uri = Uri.parse(
      '$_baseUrl/events',
    ).replace(queryParameters: {'user': userId.toString()});
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
    final cacheKey = uri.toString();
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final headers = {'Accept': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = _errorMessage(response);
        FeedbackUtils.logError(
          "GET $uri failed (${response.statusCode}): $message",
        );
        throw Exception(
          'Si è verificato un errore nel caricamento degli eventi. Riprova più tardi.',
        );
      }

      final decoded = jsonDecode(response.body);
      final dynamic rawList = switch (decoded) {
        final Map<String, dynamic> map => map['events'] ?? map['data'] ?? map,
        final List<dynamic> list => list,
        _ => decoded,
      };

      if (rawList is! List) {
        FeedbackUtils.logError("Unexpected format from $uri: ${response.body}");
        throw Exception('Errore nel formato dei dati riceveuti.');
      }
      final events = rawList
          .whereType<Map<String, dynamic>>()
          .map(EventModel.fromJson)
          .toList();
      _cache[cacheKey] = events;
      return events;
    } catch (e) {
      if (e is Exception) rethrow;
      FeedbackUtils.logError("Connection error on $uri: $e");
      throw Exception('Controlla la tua connessione internet e riprova.');
    }
  }

  Future<EventModel> createEvent({
    required String token,
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required EventType eventType,
    required int maxParticipants,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final uri = Uri.parse('$_baseUrl/event');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
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
        FeedbackUtils.logError(
          "POST $uri failed (${response.statusCode}): $message",
        );
        throw Exception(
          'Non è stato possibile creare l\'evento. Verifica i dati inseriti.',
        );
      }

      final decoded = jsonDecode(response.body);
      final rawEvent = decoded is Map<String, dynamic>
          ? decoded['event'] ?? decoded['data'] ?? decoded
          : decoded;

      if (rawEvent is! Map<String, dynamic>) {
        FeedbackUtils.logError("Invalid event response: ${response.body}");
        throw Exception('Errore nella risposta del server.');
      }
      _clearCache();
      return EventModel.fromJson(rawEvent);
    } catch (e) {
      if (e is Exception) rethrow;
      FeedbackUtils.logError("Exception during createEvent: $e");
      throw Exception(
        'Si è verificato un errore imprevisto durante la creazione.',
      );
    }
  }

  Future<void> participate({
    required String token,
    required int eventId,
  }) async {
    final uri = Uri.parse('$_baseUrl/event/$eventId/participation');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = _errorMessage(response);
        FeedbackUtils.logError(
          "Participation failed for event $eventId: $message",
        );
        throw Exception(
          'Non è stato possibile registrarti all\'evento. Riprova tra poco.',
        );
      }
      _clearCache();
    } catch (e) {
      FeedbackUtils.logError("Exception in participate: $e");
      throw Exception('Errore durante l\'iscrizione all\'evento.');
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
