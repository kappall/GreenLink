import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/core/common/widgets/paginated_result.dart';
import 'package:greenlinkapp/core/utils/feedback_utils.dart';
import 'package:greenlinkapp/features/auth/utils/role_parser.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/providers/auth_provider.dart';
import '../../feed/models/comment_model.dart';
import '../models/report.dart';
import '../services/admin_service.dart';

part 'admin_provider.g.dart';

@riverpod
AdminService adminService(Ref ref) {
  final authAsync = ref.watch(authProvider);

  final token = authAsync.value?.token;
  if (token == null) {
    throw StateError('AdminService requested without a valid token');
  }

  return AdminService(token: token);
}

@Riverpod(keepAlive: true)
class Reports extends _$Reports {
  static const _pageSize = 20;
  bool _isLoadingMore = false;

  AdminService get _adminService => ref.read(adminServiceProvider);

  @override
  FutureOr<PaginatedResult<Report>> build() async {
    return _fetchPage(1);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPage(1));
  }

  Future<PaginatedResult<Report>> _fetchPage(int page) async {
    try {
      final reports = await _adminService.getReports(
        skip: (page - 1) * _pageSize,
        limit: _pageSize,
      );

      return PaginatedResult<Report>(
        items: reports,
        page: page,
        hasMore: reports.length == _pageSize,
      );
    } catch (e) {
      FeedbackUtils.logError(e);
      rethrow;
    }
  }

  Future<void> moderateReport({
    required Report report,
    required bool approve,
  }) async {
    try {
      await _adminService.moderateReport(report: report, approve: approve);
      await refresh();
    } catch (e) {
      FeedbackUtils.logError(e);
      rethrow;
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (_isLoadingMore || current == null || !current.hasMore) return;
    _isLoadingMore = true;

    try {
      final nextPage = current.page + 1;
      final newPage = await _fetchPage(nextPage);
      final currentReports = current.items;
      final allReports = [...currentReports, ...newPage.items];
      final uniqueReports = allReports.toSet().toList();

      state = AsyncValue.data(
        state.value!.copyWith(
          items: uniqueReports,
          page: nextPage,
          hasMore: newPage.hasMore,
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}

@Riverpod(keepAlive: true)
class Users extends _$Users {
  static const _pageSize = 20;

  bool _isLoadingMore = false;

  AdminService get _adminService => ref.read(adminServiceProvider);

  @override
  FutureOr<PaginatedResult<UserModel>> build() async {
    return _fetchPage(1);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPage(1));
  }

  Future<PaginatedResult<UserModel>> _fetchPage(int page) async {
    try {
      final skip = (page - 1) * _pageSize;

      final users = await _adminService.getUsers(skip: skip, limit: _pageSize);

      final partners = await _adminService.getPartners(
        skip: skip,
        limit: _pageSize,
      );

      final combined = [...users, ...partners];

      return PaginatedResult<UserModel>(
        items: combined,
        page: page,
        hasMore: combined.length == _pageSize * 2,
      );
    } catch (e) {
      FeedbackUtils.logError(e);
      rethrow;
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || _isLoadingMore || !current.hasMore) return;

    _isLoadingMore = true;

    try {
      final nextPage = current.page + 1;
      final next = await _fetchPage(nextPage);

      final merged = [...current.items, ...next.items].toSet().toList();

      state = AsyncValue.data(
        current.copyWith(items: merged, page: nextPage, hasMore: next.hasMore),
      );
    } catch (e) {
      FeedbackUtils.logError(e);
      rethrow;
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> blockUser({required int userId}) async {
    try {
      await _adminService.blockUser(userId);
    } catch (e) {
      FeedbackUtils.logError(e);
    }
  }
}

@riverpod
class UserActions extends _$UserActions {
  @override
  void build() {}

  Future<void> blockUser(int userId) async {
    await ref.read(adminServiceProvider).blockUser(userId);
    ref.invalidate(usersProvider);
  }
}

@riverpod
class Partner extends _$Partner {
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

@riverpod
class UsersSearchQuery extends _$UsersSearchQuery {
  @override
  String build() => '';

  void setSearchQuery(String query) {
    state = query;
  }
}

@riverpod
class UserRoleFilter extends _$UserRoleFilter {
  @override
  AuthRole? build() => null;

  void setRoleFilter(AuthRole? role) {
    state = role;
  }
}

// Derived Providers
@riverpod
List<UserModel> filteredUsers(Ref ref) {
  final usersAsync = ref.watch(usersProvider);
  final query = ref.watch(usersSearchQueryProvider).toLowerCase();
  final selectedRole = ref.watch(userRoleFilterProvider);

  return usersAsync.maybeWhen(
    data: (paginated) {
      var users = paginated.items;

      if (selectedRole != null) {
        users = users.where((u) => u.role == selectedRole).toList();
      }

      if (query.isEmpty) return users;

      return users
          .where(
            (u) =>
                u.displayName.toLowerCase().contains(query) ||
                u.email.toLowerCase().contains(query),
          )
          .toList();
    },
    orElse: () => const [],
  );
}

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
