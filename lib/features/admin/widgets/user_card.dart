import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../auth/utils/role_parser.dart';
import '../../user/models/user_model.dart';

extension AuthRoleColor on AuthRole? {
  Color get color {
    switch (this) {
      case AuthRole.partner:
        return Colors.blue;
      case AuthRole.user:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onOptionsTap;

  const UserCard({super.key, required this.user, required this.onOptionsTap});

  @override
  Widget build(BuildContext context) {
    final roleColor = user.role.color;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: user.isBlocked
            ? Border.all(color: Colors.red.shade300, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => context.push('/admin/users/${user.id}', extra: user),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: roleColor.withValues(alpha: 0.1),
              child: Text(
                user.displayName.isNotEmpty
                    ? user.displayName[0].toUpperCase()
                    : "?",
                style: TextStyle(color: roleColor, fontWeight: FontWeight.bold),
              ),
            ),
            if (user.isBlocked)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(Icons.block, size: 14, color: Colors.white),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                user.displayName,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.email,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: roleColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: roleColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                roleLabel(user.role!),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: roleColor,
                ),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.grey),
          onPressed: onOptionsTap,
        ),
      ),
    );
  }
}
