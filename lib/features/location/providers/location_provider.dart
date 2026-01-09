import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/location/models/user_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocationNotifier extends AsyncNotifier<UserLocation?> {
  static const String _storageKey = 'user_location_data';

  @override
  Future<UserLocation?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      try {
        return UserLocation.fromJson(json.decode(jsonString));
      } catch (e) {
        await prefs.remove(_storageKey);
        return null;
      }
    }
    return null;
  }

  Future<void> setLocation(UserLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, json.encode(location.toJson()));
    state = AsyncData(location);
  }

  Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    state = const AsyncData(null);
  }
}

final userLocationProvider =
    AsyncNotifierProvider<UserLocationNotifier, UserLocation?>(() {
  return UserLocationNotifier();
});
