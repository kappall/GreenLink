import 'dart:convert';

import 'package:greenlinkapp/core/common/widgets/paginated_result.dart';
import 'package:greenlinkapp/core/utils/feedback_utils.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';
import 'package:http/http.dart' as http;

class EventService {
  EventService._();
  static final EventService instance = EventService._();

  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';
  final Map<String, PaginatedResult<EventModel>> _cache = {};

  void _clearCache() {
    _cache.clear();
  }

  Future<PaginatedResult<EventModel>> fetchAllEvents({
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

  Future<PaginatedResult<EventModel>> fetchEventsByDistance({
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

  Future<PaginatedResult<EventModel>> fetchEventsByUserId({
    required String? token,
    required int userId,
    int? skip,
    int? limit,
  }) {
    final uri = Uri.parse('$_baseUrl/events').replace(
      queryParameters: {
        'user': userId.toString(),
        'skip': skip?.toString() ?? '0',
        'limit': limit?.toString() ?? '20',
      },
    );
    return _requestEvents(uri: uri, token: token);
  }

  Future<PaginatedResult<EventModel>> fetchEvents({
    required String token,
    int? partnerId,
    int? skip,
    int? limit,
  }) async {
    final uri = Uri.parse('$_baseUrl/events').replace(
      queryParameters: {
        if (partnerId != null && partnerId > 0) 'partner': partnerId.toString(),
        'skip': skip?.toString() ?? '0',
        'limit': limit?.toString() ?? '20',
      },
    );

    return _requestEvents(uri: uri, token: token);
  }

  Future<List<UserModel>> fetchEventParticipants({
    required String? token,
    required int eventId,
  }) async {
    final uri = Uri.parse('$_baseUrl/event/$eventId');

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
          'Non è stato possibile recuperare i partecipanti. Riprova più tardi.',
        );
      }

      final decoded = jsonDecode(response.body);
      final dynamic rawEvent = decoded is Map<String, dynamic>
          ? decoded['event'] ?? decoded['data'] ?? decoded
          : decoded;

      if (rawEvent is Map<String, dynamic>) {
        final participants = rawEvent['participants'];
        if (participants is List) {
          return participants
              .whereType<Map<String, dynamic>>()
              .map(UserModel.fromJson)
              .toList();
        }
      }

      return [];
    } catch (e) {
      if (e is Exception) rethrow;
      FeedbackUtils.logError("Connection error on $uri: $e");
      throw Exception('Controlla la tua connessione internet e riprova.');
    }
  }

  Future<PaginatedResult<EventModel>> _requestEvents({
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

      final totalItems =
          int.tryParse(response.headers['total-items'] ?? '') ?? 0;

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

      final result = PaginatedResult(items: events, totalItems: totalItems);

      _cache[cacheKey] = result;
      return result;
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

  Future<String> participate({
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
      final ticket = _extractTicket(response.body);
      if (ticket.isEmpty) {
        FeedbackUtils.logError(
          'Ticket mancante nella risposta: ${response.body}',
        );
        throw Exception('Ticket non valido nella risposta del server.');
      }
      _clearCache();
      return ticket;
    } catch (e) {
      FeedbackUtils.logError("Exception in participate: $e");
      throw Exception('Errore durante l\'iscrizione all\'evento.');
    }
  }

  Future<void> cancelParticipation({
    required String token,
    required int eventId,
  }) async {
    final uri = Uri.parse('$_baseUrl/event/$eventId/participation');
    try {
      final response = await http.delete(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = _errorMessage(response);
        FeedbackUtils.logError(
          "Cancel participation failed for event $eventId: $message",
        );
        throw Exception(
          'Non è stato possibile annullare la partecipazione. Riprova tra poco.',
        );
      }
      _clearCache();
    } catch (e) {
      FeedbackUtils.logError("Exception in cancelParticipation: $e");
      throw Exception('Errore durante la disiscrizione dall\'evento.');
    }
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
