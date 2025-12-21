import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:greenlinkapp/features/admin/models/PartnerModel.dart';
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
          // Se il ruolo non è presente nel JSON, lo impostiamo
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
          // Se il ruolo non è presente nel JSON, lo impostiamo
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
        // Determina endpoint e ID dal tipo di content (type-safe!)
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

  Future<void> createPartner(PartnerModel partner) async {
    try {
      debugPrint(jsonEncode(partner.toJson()));
      final response = await http.post(
        Uri.parse('$_baseUrl/partner/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(partner.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Fallimento nella creazione partner: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }
}
