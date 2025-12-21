// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
  id: (json['id'] as num?)?.toInt(),
  description: json['description'] as String,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  author: UserModel.fromJson(json['author'] as Map<String, dynamic>),
  votes_count: (json['votes_count'] as num?)?.toInt() ?? 0,
  has_voted: json['has_voted'] as bool? ?? false,
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
      'created_at': instance.createdAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'author': instance.author,
      'votes_count': instance.votes_count,
      'has_voted': instance.has_voted,
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
