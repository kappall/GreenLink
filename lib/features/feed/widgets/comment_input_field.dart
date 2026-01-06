import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/feedback_utils.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/comment_provider.dart';

class CommentInputField extends ConsumerStatefulWidget {
	const CommentInputField({
		super.key,
		required this.postId,
	});

	final int postId;

	@override
	ConsumerState<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends ConsumerState<CommentInputField> {
	final TextEditingController _controller = TextEditingController();
	bool _isSending = false;

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	Future<void> _submit() async {
		if (_isSending) return;

		final text = _controller.text.trim();
		if (text.isEmpty) return;

		final authState = ref.read(authProvider).value;
		if (authState == null || authState.token == null) {
			FeedbackUtils.showError(context, "Devi accedere per commentare");
			return;
		}

		setState(() => _isSending = true);
		try {
			await ref
					.read(commentsProvider(widget.postId).notifier)
					.addComment(text, null);
			_controller.clear();
			FocusScope.of(context).unfocus();
		} catch (e) {
			FeedbackUtils.showError(context, e);
		} finally {
			if (mounted) {
				setState(() => _isSending = false);
			}
		}
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final authState = ref.watch(authProvider);
		final isLoggedIn = authState.asData?.value.token != null;

		return Material(
			color: theme.colorScheme.surface,
			elevation: 8,
			child: SafeArea(
				minimum: const EdgeInsets.fromLTRB(12, 10, 12, 12),
				child: Row(
					children: [
						Expanded(
							child: TextField(
								controller: _controller,
								enabled: isLoggedIn && !_isSending,
								minLines: 1,
								maxLines: 4,
								textInputAction: TextInputAction.newline,
								decoration: InputDecoration(
									hintText:
											isLoggedIn ? "Scrivi un commento..." : "Accedi per commentare",
									filled: true,
									fillColor: theme.colorScheme.surfaceVariant,
									contentPadding:
											const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
									border: OutlineInputBorder(
										borderRadius: BorderRadius.circular(14),
										borderSide: BorderSide(color: theme.colorScheme.outline),
									),
									enabledBorder: OutlineInputBorder(
										borderRadius: BorderRadius.circular(14),
										borderSide: BorderSide(color: theme.colorScheme.outline),
									),
									focusedBorder: OutlineInputBorder(
										borderRadius: BorderRadius.circular(14),
										borderSide: BorderSide(color: theme.colorScheme.primary),
									),
								),
								onSubmitted: (_) => _submit(),
							),
						),
						const SizedBox(width: 10),
						SizedBox(
							height: 44,
							width: 44,
							child: ElevatedButton(
								style: ElevatedButton.styleFrom(
									padding: EdgeInsets.zero,
									shape: const CircleBorder(),
									backgroundColor: isLoggedIn
											? theme.colorScheme.primary
									    : theme.colorScheme.surfaceVariant,
								),
								onPressed: (!isLoggedIn || _isSending) ? null : _submit,
								child: _isSending
										? SizedBox(
												width: 18,
												height: 18,
												child: CircularProgressIndicator(
													strokeWidth: 2,
													valueColor: AlwaysStoppedAnimation<Color>(
														theme.colorScheme.onPrimary,
													),
												),
											)
										: Icon(
												Icons.send_rounded,
												size: 18,
												color: isLoggedIn
														? theme.colorScheme.onPrimary
														: theme.colorScheme.onSurfaceVariant,
											),
							),
						),
					],
				),
			),
		);
	}
}
