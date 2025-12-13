import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';
import 'package:greenlinkapp/features/user/services/user_service.dart';

final currentUserProvider =
    AsyncNotifierProvider<CurrentUserNotifier, UserModel?>(() {
  return CurrentUserNotifier();
});

class CurrentUserNotifier extends AsyncNotifier<UserModel?> {
  final UserService _userService = UserService();

  @override
  Future<UserModel?> build() async {
    final authState = ref.watch(authProvider);
    final token = authState.asData?.value.token;

    if (token == null || token.isEmpty) return null;

    return _userService.fetchCurrentUser(token: token);
  }

  Future<void> refreshUser() async {
    final authData = ref.read(authProvider).asData?.value;
    final token = authData?.token;

    if (token == null || token.isEmpty) {
      state = const AsyncData(null);
      return;
    }

    state = const AsyncLoading();
    try {
      final user = await _userService.fetchCurrentUser(token: token);
      state = AsyncData(user);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
