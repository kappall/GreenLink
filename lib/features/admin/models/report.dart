// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

import '../../feed/models/comment_model.dart';
import '../../feed/models/post_model.dart';

part 'report.freezed.dart';
part 'report.g.dart';

enum ReportType { post, comment, event, unknown }

@Freezed(unionKey: 'type', unionValueCase: FreezedUnionCase.snake)
abstract class ReportContent with _$ReportContent {
  const factory ReportContent.post(PostModel data) = ReportContentPost;
  const factory ReportContent.event(EventModel data) = ReportContentEvent;
  const factory ReportContent.comment(CommentModel data) = ReportContentComment;

  factory ReportContent.fromJson(Map<String, dynamic> json) =>
      _$ReportContentFromJson(json);
}

@freezed
abstract class Report with _$Report {
  const Report._();

  const factory Report({
    int? id,
    required String reason,
    required UserModel author,
    required ReportContent content,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Report;

  String get reporter => author.displayName;
  String get timestamp => createdAt?.toIso8601String() ?? '';

  String get targetContent => content.when(
    post: (data) => data.description,
    event: (data) => data.description,
    comment: (data) => data.description,
  );

  String get targetId => content.when(
    post: (data) => data.id!.toString(),
    event: (data) => data.id!.toString(),
    comment: (data) => data.id.toString(),
  );

  ReportType get type => content.when(
    post: (_) => ReportType.post,
    event: (_) => ReportType.event,
    comment: (_) => ReportType.comment,
  );

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
}
