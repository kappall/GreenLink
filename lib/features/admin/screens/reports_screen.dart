import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/report_card.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  late List<dynamic> _posts;
  late List<dynamic> _events;
  late List<dynamic> _comments;

  @override
  void initState() {
    super.initState();
  }

  void _handleAction(String id, String type, bool isApprove) {
    setState(() {
      if (type == 'post') _posts.removeWhere((r) => r.id == id);
      if (type == 'event') _events.removeWhere((r) => r.id == id);
      if (type == 'comment') _comments.removeWhere((r) => r.id == id);
    });

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
                Tab(text: "Eventi", icon: Icon(Icons.calendar_today_outlined)),
                Tab(text: "Commenti", icon: Icon(Icons.comment_outlined)),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              children: [
                _buildReportList([], 'post'),
                _buildReportList([], 'event'),
                _buildReportList([], 'comment'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportList(List<dynamic> reports, String type) {
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
          onReject: () => _handleAction(report.id, type, false),
          onApprove: () => _handleAction(report.id, type, true),
        );
      },
    );
  }
}
