// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

part 'report.freezed.dart';
part 'report.g.dart';

enum ReportType { post, comment, event, unknown }

@Freezed(unionKey: 'type', unionValueCase: FreezedUnionCase.pascal)
abstract class ReportContent with _$ReportContent {
  const factory ReportContent.post({
    required int id,
    required String description,
  }) = ReportContentPost;

  const factory ReportContent.event({
    required int id,
    required String description,
  }) = ReportContentEvent;

  const factory ReportContent.comment({
    required int id,
    required String description,
  }) = ReportContentComment;

  const factory ReportContent.unknown() = ReportContentUnknown;

  factory ReportContent.fromJson(Map<String, dynamic> json) =>
      _$ReportContentFromJson(json);
}

class ReportContentConverter
    implements JsonConverter<ReportContent, Map<String, dynamic>> {
  const ReportContentConverter();

  @override
  ReportContent fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return const ReportContent.unknown();
    }
    final type = json['type'];
    if (type == 'Post' || type == 'Event' || type == 'Comment') {
      return ReportContent.fromJson(json);
    }
    return const ReportContent.unknown();
  }

  @override
  Map<String, dynamic> toJson(ReportContent object) => object.toJson();
}

@freezed
abstract class Report with _$Report {
  const Report._();

  const factory Report({
    int? id,
    required String reason,
    required UserModel? author,
    @ReportContentConverter() required ReportContent content,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Report;

  String get reporter => author?.displayName ?? "[DELETED]";
  String get timestamp => createdAt?.toIso8601String() ?? '';

  String get targetContent => content.when(
    post: (id, desc) => desc,
    event: (id, desc) => desc,
    comment: (id, desc) => desc,
    unknown: () => "Contenuto non disponibile",
  );

  String get targetId => content.when(
    post: (id, _) => id.toString(),
    event: (id, _) => id.toString(),
    comment: (id, _) => id.toString(),
    unknown: () => "N/A",
  );

  ReportType get type => content.when(
    post: (_, __) => ReportType.post,
    event: (_, __) => ReportType.event,
    comment: (_, __) => ReportType.comment,
    unknown: () => ReportType.unknown,
  );

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
}
