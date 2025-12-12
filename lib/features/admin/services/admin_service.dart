import 'dart:convert';

import 'package:greenlinkapp/features/user/models/user_model.dart';
import 'package:http/http.dart' as http;

import '../models/report.dart';

class AdminService {
  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';

  Future<List<Report>> getReports({required String token}) async {
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

  Future<List<UserModel>> getUsers({required String token}) async {
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

        final users = jsonList
            .map(
              (jsonItem) =>
                  UserModel.fromJson(jsonItem as Map<String, dynamic>),
            )
            .toList();

        return users;
      } else {
        throw Exception(
          'Fallimento nel caricamento dei report: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }
}
