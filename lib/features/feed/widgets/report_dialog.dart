import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:greenlinkapp/features/feed/providers/post_provider.dart';

import '../../../core/utils/feedback_utils.dart';
import '../models/comment_model.dart';

void showReportDialog(BuildContext context, {required Object item}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer(
        builder: (context, ref, child) {
          return AlertDialog(
            title: const Text('Segnala Contenuto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Seleziona il motivo della segnalazione:'),
                const SizedBox(height: 16),
                _ReportOption(
                  icon: Icons.spa_sharp,
                  label: 'Spam o contenuto ingannevole',
                  onTap: () => _handleReport(context, ref, item, 'spam'),
                ),
                _ReportOption(
                  icon: Icons.warning,
                  label: 'Contenuto inappropriato',
                  onTap: () =>
                      _handleReport(context, ref, item, 'inappropriate'),
                ),
                _ReportOption(
                  icon: Icons.person_off,
                  label: 'Molestie o bullismo',
                  onTap: () => _handleReport(context, ref, item, 'harassment'),
                ),
                _ReportOption(
                  icon: Icons.info_outline,
                  label: 'Informazioni false',
                  onTap: () => _handleReport(context, ref, item, 'false info'),
                ),
                _ReportOption(
                  icon: Icons.report,
                  label: 'Altro',
                  onTap: () => _handleReport(context, ref, item, 'other'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Annulla'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> _handleReport(
  BuildContext context,
  WidgetRef ref,
  Object item,
  String reason,
) async {
  try {
    int? id;

    if (item is PostModel) {
      id = item.id;
    } else if (item is EventModel) {
      id = item.id;
    } else if (item is CommentModel) {
      id = item.id;
    }

    if (id == null) {
      throw Exception('Nessun ID trovato per il contenuto da segnalare');
    }

    await ref
        .read(postsProvider(null).notifier)
        .reportContent(contentId: id, reason: reason);

    if (context.mounted) {
      Navigator.of(context).pop();
      FeedbackUtils.showSuccess(context, "Segnalazione inviata con successo");
    }
  } catch (e) {
    if (context.mounted) {
      FeedbackUtils.showError(context, "Errore durante la segnalazione: $e");
    }
  }
}

class _ReportOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ReportOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          ],
        ),
      ),
    );
  }
}
