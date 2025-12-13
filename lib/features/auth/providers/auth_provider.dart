import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/models/auth_state.dart';
import 'package:greenlinkapp/features/auth/utils/role_parser.dart';
import 'package:greenlinkapp/features/auth/services/auth_service.dart';
import 'package:greenlinkapp/features/auth/utils/auth_validators.dart';
import 'package:greenlinkapp/features/user/services/user_service.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  @override
  FutureOr<AuthState> build() {
    return AuthState.unauthenticated();
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

      final derivedRole = deriveRoleFromToken(authResult.token);

      UserModel? user;
      if (derivedRole != AuthRole.admin) {
        user = await _userService.fetchCurrentUser(
          token: authResult.token,
        );
      }

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
        user: UserModel(
          id: -1,
          email: '',
          username: 'Ospite',
        ),
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

      final user = await _userService.fetchCurrentUser(
        token: authResult.token,
      );

      final derivedRole = deriveRoleFromToken(authResult.token);

      return AuthState(
        user: user,
        token: authResult.token,
        derivedRole: derivedRole,
      );
    });
  }

  Future<UserModel?> loadCurrentUser() async {
    final authData = state.asData?.value;
    final token = authData?.token;

    if (token == null || token.isEmpty) return null;

    final cachedUser = authData?.user;
    if (cachedUser != null) return cachedUser;

    final role = authData?.role ?? deriveRoleFromToken(token);
    if (role == AuthRole.admin) return authData?.user;

    final user = await _userService.fetchCurrentUser(token: token);

    if (authData != null) {
      state = AsyncData(
        authData.copyWith(
          user: user,
          derivedRole: authData.derivedRole ?? role,
        ),
      );
    } else {
      state = AsyncData(
        AuthState(
          user: user,
          token: token,
          derivedRole: role,
        ),
      );
    }

    return user;
  }

  void logout() {
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

    state = const AsyncLoading();

    try {
      await _userService.deleteAccount(userId: userId, token: token);
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
