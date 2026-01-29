import 'dart:convert';

import 'package:greenlinkapp/core/common/widgets/paginated_result.dart';
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
        'sort': 'start_date',
        'order': 'desc',
        'skip': skip?.toString() ?? '0',
        'limit': limit?.toString() ?? '20',
      },
    );

    return _requestEvents(uri: uri, token: token);
  }

  Future<EventModel> fetchEventById({required String eventId}) async {
    final uri = Uri.parse('$_baseUrl/event/$eventId');

    final headers = {'Accept': 'application/json'};

    final response = await http.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw response;
    }

    final decoded = jsonDecode(response.body);
    final dynamic rawEvent = decoded is Map<String, dynamic>
        ? decoded['event'] ?? decoded['data'] ?? decoded
        : decoded;

    if (rawEvent is Map<String, dynamic>) {
      return EventModel.fromJson(rawEvent);
    }

    throw Exception('Invalid event data format.');
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
        'order': 'asc',
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
        'sort': 'id',
        'order': 'desc',
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
        'sort': 'id',
        'order': 'desc',
        if (partnerId != null && partnerId > 0) 'partner': partnerId.toString(),
        'skip': skip?.toString() ?? '0',
        'limit': limit?.toString() ?? '20',
      },
    );

    return _requestEvents(uri: uri, token: token);
  }

  Future<List<UserModel>> fetchEventParticipants({
    required String token,
    required int eventId,
  }) async {
    final uri = Uri.parse('$_baseUrl/event/$eventId');

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw response;
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

    final response = await http.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw response;
    }

    final totalItems = int.tryParse(response.headers['total-items'] ?? '') ?? 0;

    final decoded = jsonDecode(response.body);
    final dynamic rawList = switch (decoded) {
      final Map<String, dynamic> map => map['events'] ?? map['data'] ?? map,
      final List<dynamic> list => list,
      _ => decoded,
    };

    if (rawList is! List) {
      throw Exception('Unexpected format from $uri: ${response.body}');
    }
    final events = rawList
        .whereType<Map<String, dynamic>>()
        .map(EventModel.fromJson)
        .toList();
    final result = PaginatedResult(items: events, totalItems: totalItems);

    _cache[cacheKey] = result;
    return result;
  }

  Future<void> createEvent({
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
      throw response;
    }

    _clearCache();
  }

  Future<String> participate({
    required String token,
    required int eventId,
  }) async {
    final joinUri = Uri.parse('$_baseUrl/event/$eventId/participation');
    final eventUri = Uri.parse('$_baseUrl/event/$eventId');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final joinResponse = await http.post(
      joinUri,
      headers: {...headers, 'Content-Type': 'application/json'},
    );

    if (joinResponse.statusCode >= 200 && joinResponse.statusCode < 300) {
      final ticket = _extractTicket(joinResponse.body);
      if (ticket.isNotEmpty) {
        _clearCache();
        return ticket;
      }
    } else {
      throw joinResponse;
    }

    final response = await http.get(eventUri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw response;
    }
    final ticket = _extractTicket(response.body);
    if (ticket.isEmpty) {
      throw Exception('Missing ticket in response: ${response.body}');
    }
    _clearCache();
    return ticket;
  }

  Future<void> deleteEvent({
    required String token,
    required int eventId,
  }) async {
    final uri = Uri.parse('$_baseUrl/event/$eventId');
    final response = await http.delete(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw response;
    }
    _clearCache();
  }

  Future<void> cancelParticipation({
    required String token,
    required int eventId,
  }) async {
    final uri = Uri.parse('$_baseUrl/event/$eventId/participation');

    final response = await http.delete(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw response;
    }
    _clearCache();
  }

  String _extractTicket(String body) {
    final decoded = _tryDecode(body);

    if (decoded is String) {
      return decoded.trim();
    }

    if (decoded is Map) {
      final direct = decoded['ticket'] ?? decoded['code'];
      if (direct != null) {
        return direct.toString().trim();
      }

      final event = decoded['event'];
      if (event is Map) {
        final nested = event['ticket'] ?? event['code'];
        if (nested != null) {
          return nested.toString().trim();
        }
      }

      final data = decoded['data'];
      if (data is Map) {
        final nested = data['ticket'] ?? data['code'];
        if (nested != null) {
          return nested.toString().trim();
        }
        final dataEvent = data['event'];
        if (dataEvent is Map) {
          final nestedEvent = dataEvent['ticket'] ?? dataEvent['code'];
          if (nestedEvent != null) {
            return nestedEvent.toString().trim();
          }
        }
      } else if (data != null) {
        return data.toString().trim();
      }
    }

    return '';
  }

  dynamic _tryDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }
}
