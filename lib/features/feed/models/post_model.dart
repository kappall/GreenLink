// ignore_for_file: invalid_annotation_target

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

import 'comment_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@JsonEnum()
enum PostCategory {
  flood,
  fire,
  earthquake,
  pollution,
  storm,
  hurricane,
  other,
  unknown,
}

@freezed
abstract class PostModel with _$PostModel {
  const PostModel._();

  const factory PostModel({
    int? id,
    required String description,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    required double latitude,
    required double longitude,
    required UserModel author,
    @JsonKey(name: 'votes_count') @Default(0) int votesCount,
    @Default([]) List<CommentModel> comments,
    @JsonKey(name: 'has_voted') @Default(false) bool hasVoted,
    @JsonKey(unknownEnumValue: PostCategory.unknown)
    required PostCategory category,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

extension PostCategoryUI on PostCategory {
  String get label {
    switch (this) {
      case PostCategory.flood:
        return 'Alluvione';
      case PostCategory.fire:
        return 'Incendio';
      case PostCategory.earthquake:
        return 'Terremoto';
      case PostCategory.pollution:
        return 'Inquinamento';
      case PostCategory.storm:
        return 'Tempesta';
      case PostCategory.hurricane:
        return 'Uragano';
      case PostCategory.other:
        return 'Altro';
      case PostCategory.unknown:
        return 'Sconosciuto';
    }
  }

  IconData get icon {
    switch (this) {
      case PostCategory.flood:
        return Icons.water_drop;
      case PostCategory.fire:
        return Icons.local_fire_department;
      case PostCategory.earthquake:
        return Icons.landslide;
      case PostCategory.pollution:
        return Icons.factory;
      case PostCategory.storm:
        return Icons.storm;
      case PostCategory.hurricane:
        return Icons.cyclone;
      case PostCategory.other:
      case PostCategory.unknown:
        return Icons.warning_amber_outlined;
    }
  }

  Color get color {
    switch (this) {
      case PostCategory.flood:
        return Colors.blue;
      case PostCategory.fire:
        return Colors.red;
      case PostCategory.earthquake:
        return Colors.brown;
      case PostCategory.pollution:
        return Colors.grey;
      case PostCategory.storm:
        return Colors.indigo;
      case PostCategory.hurricane:
        return Colors.purple;
      case PostCategory.other:
      case PostCategory.unknown:
        return Colors.black;
    }
  }
}
