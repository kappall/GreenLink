import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:greenlinkapp/features/auth/utils/role_parser.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    UserModel? user,
    String? token,
    AuthRole? derivedRole,
  }) = _AuthState;

  // funziona ma non sono sicuro del suo funzionamente o se sia lo standard corretto
  bool get isLoggedIn => user != null; // quetso anche per user anonimo
  bool get isAuthenticated => isLoggedIn && token != null && token!.isNotEmpty;
  bool get hasValidToken => token != null && token!.isNotEmpty;
  bool get isAdmin => derivedRole == AuthRole.admin;
  bool get isPartner => derivedRole == AuthRole.partner;
  bool get isUser => derivedRole == AuthRole.user;

  AuthRole get role => derivedRole ?? AuthRole.unknown;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);

  factory AuthState.unauthenticated() =>
      const AuthState(user: null, token: null, derivedRole: AuthRole.unknown);
}
