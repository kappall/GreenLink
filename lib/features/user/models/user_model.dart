// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required int id,
    required String email,
    String? username,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  }) = _UserModel;

  String get displayName => username ?? email;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
