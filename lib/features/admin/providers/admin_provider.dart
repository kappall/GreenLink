import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/admin/models/user.dart';

import '../../auth/providers/auth_provider.dart';
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

final reportsListProvider = FutureProvider.autoDispose<List<Report>>((
  ref,
) async {
  final repository = ref.watch(adminServiceProvider);

  return repository.getReports();
});

final usersListProvider = FutureProvider.autoDispose<List<User>>((ref) async {
  final repository = ref.watch(adminServiceProvider);

  final results = await Future.wait([
    repository.getUsers(),
    repository.getPartners(),
  ]);

  return results.expand((userList) => userList).toList();
});
