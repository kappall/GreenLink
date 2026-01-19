import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/post_provider.dart';

Widget buildSortDropdown(WidgetRef ref, PostSortCriteria criteria) {
  return DropdownButton<PostSortCriteria>(
    value: criteria,
    underline: const SizedBox(),
    icon: const Icon(Icons.sort),
    items: const [
      DropdownMenuItem(value: PostSortCriteria.date, child: Text("Data")),
      DropdownMenuItem(value: PostSortCriteria.votes, child: Text("Voti")),
      DropdownMenuItem(
        value: PostSortCriteria.proximity,
        child: Text("Vicinanza"),
      ),
    ],
    onChanged: (value) {
      if (value != null) {
        ref.read(postSortCriteriaProvider.notifier).setCriteria(value);
      }
    },
  );
}
