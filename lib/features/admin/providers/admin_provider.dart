import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/utils/role_parser.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

import '../../auth/providers/auth_provider.dart';
import '../../feed/models/comment_model.dart';
import '../models/report.dart';
import '../services/admin_service.dart';

final adminServiceProvider = Provider<AdminService>((ref) {
  final authState = ref.watch(authProvider);
  final token = authState.asData?.value.token;

  if (token == null || token.isEmpty) {
    throw Exception('Utente non autenticato');
  }

  return AdminService(token: token);
});

class ReportsNotifier extends AsyncNotifier<List<Report>> {
  @override
  Future<List<Report>> build() async {
    return ref.read(adminServiceProvider).getReports();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(adminServiceProvider).getReports(),
    );
  }

  Future<void> moderateReport({
    required Report report,
    required bool approve,
  }) async {
    await ref
        .read(adminServiceProvider)
        .moderateReport(report: report, approve: approve);
    await refresh();
  }
}

final reportsProvider = AsyncNotifierProvider<ReportsNotifier, List<Report>>(
  ReportsNotifier.new,
);

class UsersNotifier extends AsyncNotifier<List<UserModel>> {
  @override
  Future<List<UserModel>> build() async {
    final adminService = ref.read(adminServiceProvider);
    final users = await adminService.getUsers();
    final partners = await adminService.getPartners();
    return [...users, ...partners];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final adminService = ref.read(adminServiceProvider);
      final users = await adminService.getUsers();
      final partners = await adminService.getPartners();
      return [...users, ...partners];
    });
  }
}

final usersProvider = AsyncNotifierProvider<UsersNotifier, List<UserModel>>(
  UsersNotifier.new,
);

class UserActionsNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> blockUser(int userId) async {
    await ref.read(adminServiceProvider).blockUser(userId);
    ref.invalidate(usersProvider);
  }
}

final userActionsProvider = NotifierProvider<UserActionsNotifier, void>(
  UserActionsNotifier.new,
);

class PartnerNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<String> createPartner({
    required String email,
    required String username,
  }) async {
    final token = await ref
        .read(adminServiceProvider)
        .createPartner(email: email, username: username);
    ref.invalidate(usersProvider);
    return token;
  }
}

final partnerProvider = NotifierProvider<PartnerNotifier, void>(
  PartnerNotifier.new,
);

// Search and Filter Notifiers
class UsersSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setSearchQuery(String query) {
    state = query;
  }
}

final usersSearchQueryProvider =
    NotifierProvider<UsersSearchQueryNotifier, String>(
      UsersSearchQueryNotifier.new,
    );

class UserRoleFilterNotifier extends Notifier<AuthRole?> {
  @override
  AuthRole? build() => null;

  void setRoleFilter(AuthRole? role) {
    state = role;
  }
}

final userRoleFilterProvider =
    NotifierProvider<UserRoleFilterNotifier, AuthRole?>(
      UserRoleFilterNotifier.new,
    );

// Derived Providers
final filteredUsersProvider = Provider<List<UserModel>>((ref) {
  final usersAsync = ref.watch(usersProvider);
  final query = ref.watch(usersSearchQueryProvider).toLowerCase();
  final selectedRole = ref.watch(userRoleFilterProvider);

  return usersAsync.maybeWhen(
    data: (users) {
      var filteredUsers = users;

      if (selectedRole != null) {
        filteredUsers = filteredUsers
            .where((user) => user.role == selectedRole)
            .toList();
      }

      if (query.isEmpty) {
        return filteredUsers;
      }

      return filteredUsers
          .where(
            (u) =>
                u.displayName.toLowerCase().contains(query) ||
                u.email.toLowerCase().contains(query),
          )
          .toList();
    },
    orElse: () => [],
  );
});

final activeFilteredUsersProvider = Provider<List<UserModel>>((ref) {
  final users = ref.watch(filteredUsersProvider);
  return users.where((user) => !user.isBlocked).toList();
});

final blockedFilteredUsersProvider = Provider<List<UserModel>>((ref) {
  final users = ref.watch(filteredUsersProvider);
  return users.where((user) => user.isBlocked).toList();
});

// Temporary provider for compatibility
final userCommentProvider = Provider<List<CommentModel>>((ref) => const []);
