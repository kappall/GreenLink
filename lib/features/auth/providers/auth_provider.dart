import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/models/auth_state.dart';
import 'package:greenlinkapp/features/auth/providers/onboarding_provider.dart';
import 'package:greenlinkapp/features/auth/services/auth_service.dart';
import 'package:greenlinkapp/features/auth/utils/auth_validators.dart';
import 'package:greenlinkapp/features/auth/utils/role_parser.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  final AuthService _authService = AuthService.instance;
  static const String _tokenKey = 'auth_token';

  @override
  FutureOr<AuthState> build() async {
    return _loadPersistedToken();
  }

  Future<AuthState> _loadPersistedToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null || token.isEmpty) {
      return AuthState.unauthenticated();
    }

    try {
      final user = await _authService.fetchCurrentUser(token: token);
      final derivedRole = deriveRoleFromToken(token);

      return AuthState(user: user, token: token, derivedRole: derivedRole);
    } catch (e) {
      await prefs.remove(_tokenKey);
      return AuthState.unauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final trimmedEmail = email.trim();
      final trimmedPassword = password.trim();

      validateLoginInput(trimmedEmail, trimmedPassword);

      final authResult = await _authService.login(
        email: trimmedEmail,
        password: trimmedPassword,
      );

      setPersistToken(authResult.token);

      final derivedRole = deriveRoleFromToken(authResult.token);
      final user = UserModel(id: authResult.userId, email: authResult.email);

      return AuthState(
        user: user,
        token: authResult.token,
        derivedRole: derivedRole,
      );
    });
  }

  void loginAnonymous() {
    state = const AsyncData(
      AuthState(
        user: UserModel(id: -1, email: '', username: 'Ospite'),
        derivedRole: AuthRole.unknown,
      ),
    );
  }

  Future<void> register(
    String nickname,
    String email,
    String password,
    String confirmPassword,
  ) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final trimmedNickname = nickname.trim();
      final trimmedEmail = email.trim();
      final trimmedPassword = password.trim();
      final trimmedConfirm = confirmPassword.trim();

      validateRegisterInput(
        trimmedNickname,
        trimmedEmail,
        trimmedPassword,
        trimmedConfirm,
      );

      final authResult = await _authService.register(
        username: trimmedNickname,
        email: trimmedEmail,
        password: trimmedPassword,
      );
      setPersistToken(authResult.token);

      final derivedRole = deriveRoleFromToken(authResult.token);
      final user = UserModel(id: authResult.userId, email: authResult.email);

      return AuthState(
        user: user,
        token: authResult.token,
        derivedRole: derivedRole,
      );
    });
  }

  Future<void> setPersistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> registerPartner({
    required String token,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final trimmedPassword = password.trim();

      if (trimmedPassword.length < 6) {
        throw Exception('Password troppo corta (min 6 caratteri)');
      }

      final authResult = await _authService.registerPartner(
        token: token,
        password: trimmedPassword,
      );
      setPersistToken(authResult.token);

      final derivedRole = deriveRoleFromToken(authResult.token);
      final user = UserModel(id: authResult.userId, email: authResult.email);

      return AuthState(
        user: user,
        token: authResult.token,
        derivedRole: derivedRole,
      );
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);

    state = AsyncData(AuthState.unauthenticated());
  }

  Future<void> deleteAccount() async {
    final currentState = state.asData?.value;
    final int? userId = currentState?.user?.id;
    final token = currentState?.token;

    if (currentState == null ||
        userId == null ||
        userId <= 0 ||
        token == null ||
        token.isEmpty) {
      throw Exception(
        'Impossibile eliminare l\'account senza utente autenticato.',
      );
    }
    final role = currentState.derivedRole;
    state = const AsyncLoading();

    try {
      await _authService.deleteAccount(
        userId: userId,
        role: role!,
        token: token,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);

      await ref.read(onboardingProvider.notifier).resetOnboarding();

      state = AsyncData(AuthState.unauthenticated());
    } catch (error, stackTrace) {
      state = AsyncData(currentState);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
