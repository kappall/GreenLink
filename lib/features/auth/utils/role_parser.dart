import 'package:jwt_decoder/jwt_decoder.dart';

enum AuthRole { admin, partner, user, unknown }

const _roleClaimKeys = [
  'role',
  'roles',
  'authority',
  'authorities',
  'scope',
  'scopes',
  'permissions',
];

const Map<AuthRole, List<String>> _roleAliases = {
  AuthRole.admin: ['ROLE_ADMIN', 'ADMIN'],
  AuthRole.partner: ['ROLE_PARTNER', 'PARTNER'],
  AuthRole.user: ['ROLE_USER', 'USER'],
};

AuthRole deriveRoleFromToken(String? token) {
  if (token == null || token.isEmpty) return AuthRole.unknown;

  final payload = JwtDecoder.tryDecode(token);
  if (payload is! Map<String, dynamic>) return AuthRole.unknown;

  final claim = _extractRoleClaim(payload);
  final role = _normalizeRoleClaim(claim);

  return role;
}

dynamic _extractRoleClaim(Map<String, dynamic> payload) {
  for (final key in _roleClaimKeys) {
    if (payload.containsKey(key) && payload[key] != null) {
      return payload[key];
    }
  }

  return null;
}

AuthRole _normalizeRoleClaim(dynamic claim) {
  if (claim == null) return AuthRole.unknown;

  if (claim is String) {
    final directRole = _mapRoleValue(claim);
    if (directRole != AuthRole.unknown) {
      return directRole;
    }

    final splitRoles = claim
        .split(RegExp(r'[\s,]+'))
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .map(_mapRoleValue)
        .where((role) => role != AuthRole.unknown)
        .toSet();

    if (splitRoles.contains(AuthRole.admin)) return AuthRole.admin;
    if (splitRoles.contains(AuthRole.partner)) return AuthRole.partner;
    if (splitRoles.contains(AuthRole.user)) return AuthRole.user;

    return AuthRole.unknown;
  }

  if (claim is List) {
    final normalizedRoles = claim
        .whereType<String>()
        .map(_mapRoleValue)
        .where((role) => role != AuthRole.unknown)
        .toSet();

    if (normalizedRoles.contains(AuthRole.admin)) return AuthRole.admin;
    if (normalizedRoles.contains(AuthRole.partner)) return AuthRole.partner;
    if (normalizedRoles.contains(AuthRole.user)) return AuthRole.user;
  }

  return AuthRole.unknown;
}

AuthRole _mapRoleValue(String rawValue) {
  final normalizedValue = rawValue.trim().toUpperCase();

  for (final entry in _roleAliases.entries) {
    if (entry.value.contains(normalizedValue)) {
      return entry.key;
    }
  }

  return AuthRole.unknown;
}

String roleLabel(AuthRole role) {
  switch (role) {
    case AuthRole.admin:
      return "Admin";
    case AuthRole.partner:
      return "Partner";
    case AuthRole.user:
      return "Utente";
    case AuthRole.unknown:
      return "Ruolo non disponibile";
  }
}
