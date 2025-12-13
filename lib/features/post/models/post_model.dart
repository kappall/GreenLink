// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

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
    required int id,
    required String description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    required double latitude,
    required double longitude,
    required PostUserModel author,
    @Default(<PostUserModel>[]) List<PostUserModel> votes,
    @JsonKey(unknownEnumValue: PostCategory.unknown)
    required PostCategory category,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

@freezed
abstract class PostUserModel with _$PostUserModel {
  const PostUserModel._();

  const factory PostUserModel({
    required int id,
    required String email,
    String? password,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  }) = _PostUserModel;

  factory PostUserModel.fromJson(Map<String, dynamic> json) =>
      _$PostUserModelFromJson(json);
}
