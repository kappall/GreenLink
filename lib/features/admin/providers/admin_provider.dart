import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

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

final usersListProvider = FutureProvider.autoDispose<List<UserModel>>((
  ref,
) async {
  final repository = ref.watch(adminServiceProvider);

  return repository.getUsers();
});
