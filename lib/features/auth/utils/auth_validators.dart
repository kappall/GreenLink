class AuthValidationException implements Exception {
  final String message;

  AuthValidationException(this.message);

  @override
  String toString() => message;
}

final _emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

void validateLoginInput(String email, String password) {
  if (email.isEmpty) {
    throw AuthValidationException('Email obbligatoria');
  }
  if (!_emailRegex.hasMatch(email)) {
    throw AuthValidationException('Email non valida');
  }
  if (password.isEmpty) {
    throw AuthValidationException('Password obbligatoria');
  }
}

void validateRegisterInput(
  String nickname,
  String email,
  String password,
  String confirmPassword,
) {
  if (nickname.isEmpty) {
    throw AuthValidationException('Nickname obbligatorio');
  }
  if (nickname.length < 3) {
    throw AuthValidationException('Nickname troppo corto');
  }
  validateLoginInput(email, password);
  if (password.length < 6) {
    throw AuthValidationException('Password troppo corta (min 6 caratteri)');
  }
  if (password != confirmPassword) {
    throw AuthValidationException('Le password non coincidono');
  }
}
