// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminService)
const adminServiceProvider = AdminServiceProvider._();

final class AdminServiceProvider
    extends $FunctionalProvider<AdminService, AdminService, AdminService>
    with $Provider<AdminService> {
  const AdminServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminServiceHash();

  @$internal
  @override
  $ProviderElement<AdminService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AdminService create(Ref ref) {
    return adminService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminService>(value),
    );
  }
}

String _$adminServiceHash() => r'c95fb4ec8bc348295afaed23ed288ce561333ac3';

@ProviderFor(Reports)
const reportsProvider = ReportsProvider._();

final class ReportsProvider
    extends $AsyncNotifierProvider<Reports, PaginatedResult<Report>> {
  const ReportsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportsHash();

  @$internal
  @override
  Reports create() => Reports();
}

String _$reportsHash() => r'f7517b04f0d9a9e41e914c20525d7aa889e862d7';

abstract class _$Reports extends $AsyncNotifier<PaginatedResult<Report>> {
  FutureOr<PaginatedResult<Report>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedResult<Report>>,
              PaginatedResult<Report>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<Report>>,
                PaginatedResult<Report>
              >,
              AsyncValue<PaginatedResult<Report>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Users)
const usersProvider = UsersProvider._();

final class UsersProvider
    extends $AsyncNotifierProvider<Users, PaginatedResult<UserModel>> {
  const UsersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usersHash();

  @$internal
  @override
  Users create() => Users();
}

String _$usersHash() => r'485937048e0a8815a6ed6b1058cb3ed5065b96c9';

abstract class _$Users extends $AsyncNotifier<PaginatedResult<UserModel>> {
  FutureOr<PaginatedResult<UserModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedResult<UserModel>>,
              PaginatedResult<UserModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<UserModel>>,
                PaginatedResult<UserModel>
              >,
              AsyncValue<PaginatedResult<UserModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(UserActions)
const userActionsProvider = UserActionsProvider._();

final class UserActionsProvider extends $NotifierProvider<UserActions, void> {
  const UserActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userActionsHash();

  @$internal
  @override
  UserActions create() => UserActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$userActionsHash() => r'c004fb0a0426e22c47ebab7315ada7a7bfe0544e';

abstract class _$UserActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

@ProviderFor(Partner)
const partnerProvider = PartnerProvider._();

final class PartnerProvider extends $NotifierProvider<Partner, void> {
  const PartnerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnerHash();

  @$internal
  @override
  Partner create() => Partner();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$partnerHash() => r'b05a45fc850d789f749f3af773d16e9129409fbb';

abstract class _$Partner extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

@ProviderFor(UsersSearchQuery)
const usersSearchQueryProvider = UsersSearchQueryProvider._();

final class UsersSearchQueryProvider
    extends $NotifierProvider<UsersSearchQuery, String> {
  const UsersSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usersSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usersSearchQueryHash();

  @$internal
  @override
  UsersSearchQuery create() => UsersSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$usersSearchQueryHash() => r'1ca73f0cb41d0c62e736c398585533d62eaf8424';

abstract class _$UsersSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(UserRoleFilter)
const userRoleFilterProvider = UserRoleFilterProvider._();

final class UserRoleFilterProvider
    extends $NotifierProvider<UserRoleFilter, AuthRole?> {
  const UserRoleFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRoleFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRoleFilterHash();

  @$internal
  @override
  UserRoleFilter create() => UserRoleFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRole? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRole?>(value),
    );
  }
}

String _$userRoleFilterHash() => r'87e58a09301af39eb0d4d6697fb2a4a3427dd0f2';

abstract class _$UserRoleFilter extends $Notifier<AuthRole?> {
  AuthRole? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuthRole?, AuthRole?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthRole?, AuthRole?>,
              AuthRole?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(filteredUsers)
const filteredUsersProvider = FilteredUsersProvider._();

final class FilteredUsersProvider
    extends
        $FunctionalProvider<List<UserModel>, List<UserModel>, List<UserModel>>
    with $Provider<List<UserModel>> {
  const FilteredUsersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredUsersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredUsersHash();

  @$internal
  @override
  $ProviderElement<List<UserModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<UserModel> create(Ref ref) {
    return filteredUsers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<UserModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<UserModel>>(value),
    );
  }
}

String _$filteredUsersHash() => r'6fb44c2d11f13ffeed0c0a847aec958f4cbcf576';
