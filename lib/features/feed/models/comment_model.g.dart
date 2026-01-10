// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentModel _$CommentModelFromJson(Map<String, dynamic> json) =>
    _CommentModel(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
      author: UserModel.fromJson(json['author'] as Map<String, dynamic>),
      votes:
          (json['votes'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      contentId: _contentIdFromJson(json['content']),
      votesCount: (json['votes_count'] as num).toInt(),
      hasVoted: json['has_voted'] as bool? ?? false,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CommentModelToJson(_CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'author': instance.author,
      'votes': instance.votes,
      'content': instance.contentId,
      'votes_count': instance.votesCount,
      'has_voted': instance.hasVoted,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
