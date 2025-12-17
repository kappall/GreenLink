enum ReportType { post, comment, event, unknown }

enum ReportStatus { pending, approved, rejected }

class Report {
  final String id;
  final ReportType type;
  final String targetId;
  final String targetContent;
  final String reason;
  final String? details;
  final String reporter;
  final String timestamp;
  final ReportStatus status;

  const Report({
    required this.id,
    required this.type,
    required this.targetId,
    required this.targetContent,
    required this.reason,
    this.details,
    required this.reporter,
    required this.timestamp,
    required this.status,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as String,
      type: _parseReportType(json['type']),
      targetId: json['targetId'] as String,
      targetContent: json['targetContent'] as String,
      reason: json['reason'] as String,
      details: json['details'] as String?,
      reporter: json['reporter'] as String,
      timestamp: json['timestamp'] as String,
      status: _parseReportStatus(json['status']),
    );
  }

  static ReportType _parseReportType(String? value) {
    switch (value) {
      case 'post':
        return ReportType.post;
      case 'comment':
        return ReportType.comment;
      case 'event':
        return ReportType.event;
      default:
        return ReportType.unknown;
    }
  }

  static ReportStatus _parseReportStatus(String? value) {
    switch (value) {
      case 'approved':
        return ReportStatus.approved;
      case 'resolved':
        return ReportStatus.approved;
      case 'rejected':
        return ReportStatus.rejected;
      default:
        return ReportStatus.pending;
    }
  }
}
