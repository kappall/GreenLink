import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../auth/utils/role_parser.dart';
import '../../user/models/user_model.dart';
import '../models/report.dart';

class AdminService {
  final String token;
  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';

  AdminService({this.token = ''});

  Future<List<Report>> getReports() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/reports'),
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

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((jsonItem) {
          final user = UserModel.fromJson(jsonItem as Map<String, dynamic>);
          return user.role == null ? user.copyWith(role: AuthRole.user) : user;
        }).toList();
      } else {
        throw Exception(
          'Fallimento nel caricamento degli user: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }

  Future<List<UserModel>> getPartners() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/partners'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((jsonItem) {
          final user = UserModel.fromJson(jsonItem as Map<String, dynamic>);
          return user.role == null
              ? user.copyWith(role: AuthRole.partner)
              : user;
        }).toList();
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
          post: (post) {
            endpoint = 'posts';
            contentId = post.id;
          },
          event: (event) {
            endpoint = 'events';
            contentId = event.id;
          },
          comment: (comment) {
            endpoint = 'comments';
            contentId = comment.id;
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

          if (response.statusCode != 200) {
            throw Exception(
              'Fallimento nella rimozione del contenuto: ${response.statusCode}',
            );
          }
        }
      }

      if (report.id != null) {
        final response = await http.delete(
          Uri.parse('$_baseUrl/reports/${report.id}'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode != 200) {
          throw Exception(
            'Fallimento nella rimozione del report: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
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
      debugPrint(response.request.toString());
      debugPrint(token);
      debugPrint(jsonEncode(payload));
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
