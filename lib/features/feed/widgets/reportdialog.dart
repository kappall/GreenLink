import 'package:flutter/material.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';

void showReportDialog(BuildContext context, {required Object item}) {


  if (item is PostModel) {

  } else if (item is EventModel) {

  } else {
    throw ArgumentError('Item must be either Post or Event');
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Segnala Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Seleziona il motivo della segnalazione:'),
            const SizedBox(height: 16),
            _ReportOption(
              icon: Icons.spa_sharp,
              label: 'Spam o contenuto ingannevole',
              onTap: () {
                if (item is PostModel) {
                  print("post");
                } else if (item is EventModel) {
                  print("event");
                }
                Navigator.of(context).pop();
              },
            ),
            _ReportOption(
              icon: Icons.warning,
              label: 'Contenuto inappropriato',
              onTap: () => Navigator.of(context).pop(),
            ),
            _ReportOption(
              icon: Icons.person_off,
              label: 'Molestie o bullismo',
              onTap: () => Navigator.of(context).pop(),
            ),
            _ReportOption(
              icon: Icons.info_outline,
              label: 'Informazioni false',
              onTap: () => Navigator.of(context).pop(),
            ),
            _ReportOption(
              icon: Icons.report,
              label: 'Altro',
              onTap: () => Navigator.of(context).pop(),
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
