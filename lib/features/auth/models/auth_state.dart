import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    UserModel? user,
    String? token,
  }) = _AuthState;

  bool get isAuthenticated => user != null || token != null;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);

  factory AuthState.unauthenticated() =>
      const AuthState(user: null, token: null);
}
