import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/comment_provider.dart';
import '../providers/reply_target_provider.dart';

class CommentInputField extends ConsumerWidget {
  final int postId;
  final _controller = TextEditingController();

  CommentInputField({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final target = ref.watch(replyTargetProvider);
    final bool isReplying = target != null;

    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isReplying)
          _ReplyHeader(
            userName: target.$2!,
            onCancel: () => ref.read(replyTargetProvider.notifier).reset(),
          ),
        Container(
          padding: EdgeInsets.only(left: 16, right: 8, top: 8),
          color: theme.colorScheme.secondaryContainer,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLength: 2000,
                  decoration: InputDecoration(
                    hintText: isReplying
                        ? "Rispondi a ${target.$2}..."
                        : "Aggiungi un commento...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                onPressed: () async {
                  final text = _controller.text.trim();
                  if (text.isEmpty) return;

                  // Invia con parentId se presente nel target
                  await ref
                      .read(commentsProvider(postId).notifier)
                      .addComment(text, target?.$1);

                  _controller.clear();
                  ref.read(replyTargetProvider.notifier).reset();
                  FocusScope.of(context).unfocus();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ReplyHeader({
    required String userName,
    required VoidCallback onCancel,
  }) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            "Risposta a @$userName",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onCancel,
            child: const Icon(Icons.close, size: 16),
          ),
        ],
      ),
    );
  }
}
