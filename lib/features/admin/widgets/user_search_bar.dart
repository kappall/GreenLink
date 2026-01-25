import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/admin_provider.dart';

class UsersSearchBar extends ConsumerWidget {
  const UsersSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: TextField(
        onChanged: (v) => ref.read(usersSearchQueryProvider.notifier).state = v,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: "Cerca per nome o email...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
