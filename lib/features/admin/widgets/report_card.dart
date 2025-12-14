import 'package:flutter/material.dart';
import 'package:greenlinkapp/core/common/widgets/badge.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/features/admin/models/report.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback onReject;
  final VoidCallback onApprove;

  const ReportCard({
    required this.report,
    required this.onReject,
    required this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    final reason = report.reason.toString();
    Color badgeColor = Colors.grey;
    IconData badgeIcon = Icons.info;

    if (reason == 'spam') {
      badgeColor = Colors.orange;
      badgeIcon = Icons.warning_amber;
    } else if (reason == 'fake') {
      badgeColor = Colors.red;
      badgeIcon = Icons.cancel_outlined;
    } else if (reason == 'inappropriate') {
      badgeColor = Colors.purple;
      badgeIcon = Icons.block;
    }

    final content = report.targetContent;
    final reporter = report.reporter;
    final timestamp = report.timestamp;

    return UiCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UiBadge(
                label: reason.toUpperCase(),
                color: badgeColor,
                icon: badgeIcon,
              ),
              Text(
                timestamp,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.flag, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "Segnalato da ",
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              Text(
                reporter,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contenuto:",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          if (report.details != null &&
              report.details != null &&
              report.details!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              "Note: ${report.details}",
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ],

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onReject,
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text("Respingi"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onApprove,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text("Rimuovi"),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
