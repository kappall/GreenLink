import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

final currentUserProvider =
    AsyncNotifierProvider<CurrentUserNotifier, UserModel?>(() {
  return CurrentUserNotifier();
});

class CurrentUserNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    ref.watch(authProvider);
    return ref.read(authProvider.notifier).loadCurrentUser();
  }

  Future<void> refreshUser() async {
    final user = await ref.read(authProvider.notifier).loadCurrentUser();
    state = AsyncData(user);
  }
}
