import 'package:greenlinkapp/features/auth/utils/role_parser.dart';

class User {
  final int id;
  final String email;
  final String? username;
  final AuthRole role;
  final DateTime? deletedAt;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    this.username,
    required this.role,
    this.deletedAt,
    required this.createdAt,
  });

  set role(AuthRole value) {
    role = value;
  }

  get displayName => username ?? email;
  get isBlocked => deletedAt != null;

  factory User.fromJson(Map<String, dynamic> json, AuthRole role) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String?,
      role: role,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'role': role.toString(),
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
