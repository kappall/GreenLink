import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/utils/role_parser.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

import '../../auth/providers/auth_provider.dart';
import '../../feed/models/comment_model.dart';
import '../models/report.dart';
import '../services/admin_service.dart';

class ReportsNotifier extends AsyncNotifier<List<Report>> {
  @override
  Future<List<Report>> build() async {
    return _fetchReports();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchReports());
  }

  Future<List<Report>> _fetchReports() async {
    final authState = ref.watch(authProvider);
    final token = authState.asData?.value.token;

    if (token == null || token.isEmpty) {
      return <Report>[];
    }

    return ref.read(adminServiceProvider).getReports();
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
    return _fetchUsers();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchUsers());
  }

  Future<List<UserModel>> _fetchUsers() async {
    final authState = ref.watch(authProvider);
    final token = authState.asData?.value.token;

    if (token == null || token.isEmpty) {
      return <UserModel>[];
    }

    final adminService = ref.read(adminServiceProvider);
    final users = await adminService.getUsers();
    final partners = await adminService.getPartners();

    return [...users, ...partners];
  }

  Future<void> blockUser(int userId) async {
    await ref.read(adminServiceProvider).blockUser(userId);
    await refresh();
  }

  Future<String> createPartner({
    required String email,
    required String username,
  }) async {
    final partnerToken = await ref
        .read(adminServiceProvider)
        .createPartner(email: email, username: username);
    await refresh();
    return partnerToken;
  }
}

final usersProvider = AsyncNotifierProvider<UsersNotifier, List<UserModel>>(
  UsersNotifier.new,
);

// Search Query Notifier
class UsersSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  @override
  set state(String value) => super.state = value;
}

final usersSearchQueryProvider =
    NotifierProvider<UsersSearchQueryNotifier, String>(
      UsersSearchQueryNotifier.new,
    );

// Role Filter Notifier
class UserRoleFilterNotifier extends Notifier<AuthRole?> {
  @override
  AuthRole? build() => null;

  @override
  set state(AuthRole? value) => super.state = value;
}

final userRoleFilterProvider =
    NotifierProvider<UserRoleFilterNotifier, AuthRole?>(
      UserRoleFilterNotifier.new,
    );

// TODO: Provider temporaneo per compatibilità - da collegare a vero backend
final userCommentProvider = Provider<List<CommentModel>>((ref) => const []);

// Derived providers
final usersCountProvider = Provider<int>((ref) {
  final usersAsync = ref.watch(usersProvider);
  return usersAsync.maybeWhen(data: (users) => users.length, orElse: () => 0);
});

final reportsCountProvider = Provider<int>((ref) {
  final reportsAsync = ref.watch(reportsProvider);
  return reportsAsync.maybeWhen(
    data: (reports) => reports.length,
    orElse: () => 0,
  );
});

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
    orElse: () => const [],
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

final reportsListProvider = reportsProvider;
final usersListProvider = usersProvider;

final adminServiceProvider = Provider<AdminService>((ref) {
  final authState = ref.watch(authProvider);
  final token = authState.asData?.value.token;

  if (token == null || token.isEmpty) {
    throw Exception('Utente non autenticato');
  }

  return AdminService(token: token);
});
