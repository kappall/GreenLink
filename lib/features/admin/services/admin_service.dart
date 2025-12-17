import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
        final users = jsonList.map((jsonItem) {
          final json = jsonItem as Map<String, dynamic>;
          json['role'] = AuthRole.user.name;
          debugPrint(json.toString());
          return UserModel.fromJson(json);
        }).toList();

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
        final users = jsonList.map((jsonItem) {
          final json = jsonItem as Map<String, dynamic>;
          json['role'] = AuthRole.partner.name;
          return UserModel.fromJson(json);
        }).toList();

        return users;
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
        String endpoint;
        switch (report.type) {
          case ReportType.post:
            endpoint = 'posts';
            break;
          case ReportType.comment:
            endpoint = 'comments';
            break;
          case ReportType.event:
            endpoint = 'events';
            break;
          case ReportType.unknown:
            return;
        }

        final response = await http.delete(
          Uri.parse('$_baseUrl/$endpoint/${report.targetId}'),
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
          'Fallimento nella modifica del ruolo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }
}
