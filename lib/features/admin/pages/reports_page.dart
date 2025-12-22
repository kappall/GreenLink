import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/event/providers/event_provider.dart';
import 'package:greenlinkapp/features/event/widgets/event_feed.dart';
import 'package:greenlinkapp/features/feed/providers/post_provider.dart';
import 'package:greenlinkapp/features/feed/widgets/post_feed.dart';

import '../models/report.dart';
import '../providers/admin_provider.dart';
import '../widgets/report_card.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  bool _showOnlyReported = true;

  void _handleAction(Report report, bool isApprove) async {
    await ref
        .read(reportsProvider.notifier)
        .moderateReport(report: report, approve: isApprove);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestione Contenuti"),
        actions: [
          Row(
            children: [
              const Text("Solo segnalati", style: TextStyle(fontSize: 12)),
              Switch(
                value: _showOnlyReported,
                onChanged: (val) => setState(() => _showOnlyReported = val),
              ),
            ],
          ),
        ],
      ),
      body: _showOnlyReported ? _buildReportedView() : _buildAllContentView(),
    );
  }

  Widget _buildReportedView() {
    final reportsAsync = ref.watch(reportsProvider);

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

  Widget _buildAllContentView() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
              tabs: [
                Tab(text: "Tutti i Post", icon: Icon(Icons.feed_outlined)),
                Tab(
                  text: "Tutti gli Eventi",
                  icon: Icon(Icons.event_note_outlined),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [_buildAllPostsList(), _buildAllEventsList()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllPostsList() {
    final postsAsync = ref.watch(userPostsProvider(null));
    return CustomScrollView(slivers: [PostFeed(postsAsync: postsAsync)]);
  }

  Widget _buildAllEventsList() {
    final eventsAsync = ref.watch(eventsProvider);
    return CustomScrollView(slivers: [EventFeed(eventsAsync: eventsAsync)]);
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
