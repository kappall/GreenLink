// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
abstract class CommentModel with _$CommentModel {
  const CommentModel._();

  const factory CommentModel({
    int? id,
    required String description,
    required UserModel author,
    @Default(<UserModel>[]) List<UserModel> votes,
    required PostModel content,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _CommentModel;

  // Getter per compatibilità con UI esistente
  int get userId => author.id;
  int get postId => content.id ?? 0;
  String get text => description;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}
