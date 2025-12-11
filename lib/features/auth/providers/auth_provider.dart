import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/models/auth_state.dart';
import 'package:greenlinkapp/features/auth/services/auth_service.dart';
import 'package:greenlinkapp/features/auth/utils/auth_validators.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  final AuthService _authService = AuthService();

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

      final token = await _authService.login(
        email: trimmedEmail,
        password: trimmedPassword,
      );
      return AuthState(
        user: UserModel(email: trimmedEmail),
        token: token,
      );
    });
  }

  void loginAnonymous() {
    state = const AsyncData(
      AuthState(
        user: UserModel(
          id: 'anonymous',
          displayName: 'Ospite',
        ),
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

      final token = await _authService.register(
        username: trimmedNickname,
        email: trimmedEmail,
        password: trimmedPassword,
      );
      return AuthState(
        user:
            UserModel(email: trimmedEmail, displayName: trimmedNickname),
        token: token,
      );
    });
  }

  void logout() {
    state = AsyncData(AuthState.unauthenticated());
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
