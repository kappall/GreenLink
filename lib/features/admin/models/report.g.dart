// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportContentPost _$ReportContentPostFromJson(Map<String, dynamic> json) =>
    ReportContentPost(
      PostModel.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$ReportContentPostToJson(ReportContentPost instance) =>
    <String, dynamic>{'data': instance.data, 'type': instance.$type};

ReportContentEvent _$ReportContentEventFromJson(Map<String, dynamic> json) =>
    ReportContentEvent(
      EventModel.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$ReportContentEventToJson(ReportContentEvent instance) =>
    <String, dynamic>{'data': instance.data, 'type': instance.$type};

ReportContentComment _$ReportContentCommentFromJson(
  Map<String, dynamic> json,
) => ReportContentComment(
  CommentModel.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$ReportContentCommentToJson(
  ReportContentComment instance,
) => <String, dynamic>{'data': instance.data, 'type': instance.$type};

_Report _$ReportFromJson(Map<String, dynamic> json) => _Report(
  id: (json['id'] as num?)?.toInt(),
  reason: json['reason'] as String,
  author: UserModel.fromJson(json['author'] as Map<String, dynamic>),
  content: ReportContent.fromJson(json['content'] as Map<String, dynamic>),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ReportToJson(_Report instance) => <String, dynamic>{
  'id': instance.id,
  'reason': instance.reason,
  'author': instance.author,
  'content': instance.content,
  'deleted_at': instance.deletedAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
};
