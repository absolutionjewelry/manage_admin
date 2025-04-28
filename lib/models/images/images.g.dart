// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) => Image(
  id: json['id'] as String?,
  storeId: json['storeId'] as String?,
  contentType: json['image_content_type'] as String?,
  content: json['image_content'] as String?,
  name: json['image_name'] as String?,
  description: json['image_description'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  archivedAt:
      json['archivedAt'] == null
          ? null
          : DateTime.parse(json['archivedAt'] as String),
);

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
  'id': instance.id,
  'storeId': instance.storeId,
  'image_content_type': instance.contentType,
  'image_content': instance.content,
  'image_name': instance.name,
  'image_description': instance.description,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'archivedAt': instance.archivedAt?.toIso8601String(),
};
