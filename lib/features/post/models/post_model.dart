// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

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
  unknown
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
    UserModel? author,
    @Default(<UserModel>[]) List<UserModel> votes,
    @JsonKey(unknownEnumValue: PostCategory.unknown)
    required PostCategory category,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
