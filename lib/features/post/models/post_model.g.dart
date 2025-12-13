// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
  id: (json['id'] as num).toInt(),
  description: json['description'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  author: PostUserModel.fromJson(json['author'] as Map<String, dynamic>),
  votes:
      (json['votes'] as List<dynamic>?)
          ?.map((e) => PostUserModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PostUserModel>[],
  category: $enumDecode(
    _$PostCategoryEnumMap,
    json['category'],
    unknownValue: PostCategory.unknown,
  ),
);

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'created_at': instance.createdAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'author': instance.author,
      'votes': instance.votes,
      'category': _$PostCategoryEnumMap[instance.category]!,
    };

const _$PostCategoryEnumMap = {
  PostCategory.flood: 'flood',
  PostCategory.fire: 'fire',
  PostCategory.earthquake: 'earthquake',
  PostCategory.pollution: 'pollution',
  PostCategory.storm: 'storm',
  PostCategory.hurricane: 'hurricane',
  PostCategory.other: 'other',
  PostCategory.unknown: 'unknown',
};

_PostUserModel _$PostUserModelFromJson(Map<String, dynamic> json) =>
    _PostUserModel(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      password: json['password'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$PostUserModelToJson(_PostUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'password': instance.password,
      'created_at': instance.createdAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
