import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:greenlinkapp/features/auth/utils/role_parser.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

import '../../auth/providers/auth_provider.dart';
import '../models/comment_model.dart';
import '../models/report.dart';
import '../services/admin_service.dart';

final adminServiceProvider = Provider<AdminService>((ref) {
  final authState = ref.watch(authProvider);
  final token = authState.asData?.value.token;

  if (token == null) {
    throw Exception("Utente non autenticato");
  }
  return AdminService(token: token);
});

final reportsListProvider = FutureProvider<List<Report>>((ref) async {
  final repository = ref.watch(adminServiceProvider);

  return repository.getReports();
});

final usersListProvider = FutureProvider<List<UserModel>>((ref) async {
  final repository = ref.watch(adminServiceProvider);

  final users = await repository.getUsers();
  final partners = await repository.getPartners();

  return [...users, ...partners];
});

final userCommentProvider = Provider<List<CommentModel>>((ref) {
  return [
    CommentModel(
      id: 1,
      text: 'Questo è un commento di prova.',
      userId: 1,
      postId: 1,
      createdAt: DateTime.now(),
    ),
    CommentModel(
      id: 2,
      text: 'Questo è un altro commento di prova.',
      userId: 2,
      postId: 1,
      createdAt: DateTime.now(),
    ),
  ];
});

final usersCountProvider = Provider<int>((ref) {
  final usersAsync = ref.watch(usersListProvider);
  return usersAsync.maybeWhen(data: (users) => users.length, orElse: () => 0);
});

final reportsCountProvider = Provider<int>((ref) {
  final reportsAsync = ref.watch(reportsListProvider);
  return reportsAsync.maybeWhen(
    data: (reports) => reports.length,
    orElse: () => 0,
  );
});

final usersSearchQueryProvider = StateProvider<String>((_) => '');

final userRoleFilterProvider = StateProvider<AuthRole?>((_) => null);

final filteredUsersProvider = Provider<List<UserModel>>((ref) {
  final usersAsync = ref.watch(usersListProvider);
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
