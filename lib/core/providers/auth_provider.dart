import 'package:riverpod/riverpod.dart';
import '../../data/models.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isAuthenticated => user != null;

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    await Future.delayed(
      const Duration(milliseconds: 1000),
    ); // TODO: qua chiamata a repository, per Tommaso
    state = AuthState(user: null, isLoading: false);
  }

  void loginAnonymous() {
    state = const AuthState(user: User(), isLoading: false);
  }

  Future<void> register(String nickname, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 1000));

    // Login automatico dopo la registrazione
    state = AuthState(user: User(), isLoading: false);
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
