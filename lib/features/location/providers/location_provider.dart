import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_location.dart';

class UserLocationNotifier extends Notifier<UserLocation?> {
  static const String _storageKey = 'user_location_data';

  @override
  UserLocation? build() {
    _loadLocation();
    return null;
  }

  Future<void> _loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      try {
        state = UserLocation.fromJson(json.decode(jsonString));
      } catch (e) {
        // Ignora errori di parsing
        await prefs.remove(_storageKey);
      }
    }
  }

  Future<void> setLocation(UserLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, json.encode(location.toJson()));
    state = location;
  }

  Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    state = null;
  }
}

final userLocationProvider =
    NotifierProvider<UserLocationNotifier, UserLocation?>(() {
      return UserLocationNotifier();
    });
