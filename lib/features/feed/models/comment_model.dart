import 'package:freezed_annotation/freezed_annotation.dart';

import '../../user/models/user_model.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
abstract class CommentModel with _$CommentModel {
  const factory CommentModel({
    required int id,
    required String description,
    required UserModel author,
    @Default([]) List<UserModel> votes,
    @JsonKey(name: 'votes_count') required int votesCount,
    @JsonKey(name: 'has_voted') @Default(false) bool hasVoted,
    required int content,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}
