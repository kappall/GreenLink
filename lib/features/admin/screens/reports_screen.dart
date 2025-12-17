import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/report.dart';
import '../providers/admin_provider.dart';
import '../widgets/report_card.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  void _handleAction(Report report, bool isApprove) async {
    await ref
        .read(adminServiceProvider)
        .moderateReport(report: report, approve: isApprove);
    ref.invalidate(reportsListProvider);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isApprove ? "Contenuto rimosso" : "Segnalazione respinta",
        ),
        backgroundColor: isApprove ? Colors.red : Colors.grey,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(reportsListProvider);

    return reportsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      data: (reports) {
        final posts = reports.where((r) => r.type == ReportType.post).toList();
        final events = reports
            .where((r) => r.type == ReportType.event)
            .toList();
        final comments = reports
            .where((r) => r.type == ReportType.comment)
            .toList();

        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: const TabBar(
                  labelColor: Colors.indigo,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.indigo,
                  tabs: [
                    Tab(text: "Post", icon: Icon(Icons.message_outlined)),
                    Tab(
                      text: "Eventi",
                      icon: Icon(Icons.calendar_today_outlined),
                    ),
                    Tab(text: "Commenti", icon: Icon(Icons.comment_outlined)),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildReportList(posts),
                    _buildReportList(events),
                    _buildReportList(comments),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportList(List<Report> reports) {
    if (reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green.shade200,
            ),
            const SizedBox(height: 16),
            const Text(
              "Nessuna segnalazione.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final report = reports[index];
        return ReportCard(
          report: report,
          onReject: () => _handleAction(report, false),
          onApprove: () => _handleAction(report, true),
        );
      },
    );
  }
}
