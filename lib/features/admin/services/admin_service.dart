import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

import '../../auth/utils/role_parser.dart';
import '../../user/models/user_model.dart';
import '../models/report.dart';

final adminServiceProvider = Provider<AdminService>((ref) {
  final token = ref.watch(authProvider).asData?.value.token ?? '';
  return AdminService(token: token);
});

//TODO: skip and limit
class AdminService {
  AdminService({required this.token});
  final String token;

  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';
  final Map<String, List<Report>> _reportCache = {};
  final Map<String, List<UserModel>> _userCache = {};

  void _clearReportCache() {
    _reportCache.clear();
  }

  void _clearUserCache() {
    _userCache.clear();
  }

  Future<List<Report>> getReports({
    int? skip,
    int? limit,
    bool refresh = false,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/reports').replace(
        queryParameters: {
          'sort': 'id',
          'order': 'desc',
          'skip': skip?.toString() ?? '0',
          'limit': limit?.toString() ?? '20',
        },
      );
      final cacheKey = uri.toString();
      if (_reportCache.containsKey(cacheKey) && !refresh) {
        return _reportCache[cacheKey]!;
      }
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final reports = jsonList
            .map(
              (jsonItem) => Report.fromJson(jsonItem as Map<String, dynamic>),
            )
            .toList();
        _reportCache[cacheKey] = reports;
        return reports;
      } else {
        throw Exception(
          'Fallimento nel caricamento dei report: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }

  Future<List<UserModel>> getUsers({
    int? skip,
    int? limit,
    bool refresh = false,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/users').replace(
        queryParameters: {
          'sort': 'id',
          'order': 'desc',
          'skip': skip?.toString() ?? '0',
          'limit': limit?.toString() ?? '20',
        },
      );
      final cacheKey = uri.toString();
      if (_userCache.containsKey(cacheKey) && !refresh) {
        return _userCache[cacheKey]!;
      }
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final users = jsonList.map((jsonItem) {
          final user = UserModel.fromJson(jsonItem as Map<String, dynamic>);
          return user.role == null ? user.copyWith(role: AuthRole.user) : user;
        }).toList();
        _userCache[cacheKey] = users;
        return users;
      } else {
        throw Exception(
          'Fallimento nel caricamento degli user: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }

  Future<List<UserModel>> getPartners({
    int? skip,
    int? limit,
    bool refresh = false,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/partners').replace(
        queryParameters: {
          'sort': 'id',
          'order': 'desc',
          'skip': skip?.toString() ?? '0',
          'limit': limit?.toString() ?? '20',
        },
      );
      final cacheKey = uri.toString();
      if (_userCache.containsKey(cacheKey) && !refresh) {
        return _userCache[cacheKey]!;
      }
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final partners = jsonList.map((jsonItem) {
          final user = UserModel.fromJson(jsonItem as Map<String, dynamic>);
          return user.role == null
              ? user.copyWith(role: AuthRole.partner)
              : user;
        }).toList();
        _userCache[cacheKey] = partners;
        return partners;
      } else {
        throw Exception(
          'Fallimento nel caricamento dei partner: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }

  Future<void> moderateReport({
    required Report report,
    required bool approve,
  }) async {
    try {
      if (approve) {
        String? endpoint;
        int? contentId;

        report.content.when(
          post: (id, description) {
            endpoint = 'post';
            contentId = id;
          },
          event: (id, description) {
            endpoint = 'event';
            contentId = id;
          },
          comment: (id, description) {
            endpoint = 'comment';
            contentId = id;
          },
          unknown: () {
            throw Exception('Tipo di contenuto sconosciuto');
          },
        );

        if (endpoint != null && contentId != null) {
          final response = await http.delete(
            Uri.parse('$_baseUrl/$endpoint/$contentId'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );

          if (response.statusCode < 200 || response.statusCode >= 300) {
            throw Exception(
              'Fallimento nella rimozione del contenuto: ${response.statusCode}',
            );
          }
        }
      }

      if (report.id != null) {
        final response = await http.delete(
          Uri.parse('$_baseUrl/report/${report.id}'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode < 200 || response.statusCode >= 300) {
          throw Exception(
            'Fallimento nella rimozione del report: ${response.statusCode}',
          );
        }
      }
      _clearReportCache();
    } catch (e) {
      throw Exception('Errore durante la moderazione: $e');
    }
  }

  Future<void> blockUser(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/user/$userId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Fallimento del blocco user $userId: ${response.statusCode}',
        );
      }
      _clearUserCache();
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }

  Future<String> createPartner({
    required String email,
    required String username,
  }) async {
    try {
      final payload = {'email': email, 'username': username};

      final response = await http.post(
        Uri.parse('$_baseUrl/partner/create'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Fallimento nella creazione partner: ${response.statusCode}',
        );
      }
      final body = jsonDecode(response.body);
      return body['token'];
    } catch (e) {
      throw Exception(e);
    }
  }
}
