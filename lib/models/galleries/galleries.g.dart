// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'galleries.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gallery _$GalleryFromJson(Map<String, dynamic> json) => Gallery(
  id: json['id'] as String?,
  storeId: json['storeId'] as String?,
  position: json['position'] as String?,
  name: json['gallery_name'] as String?,
  description: json['gallery_description'] as String?,
  type: $enumDecodeNullable(_$GalleryTypeEnumMap, json['gallery_type']),
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

Map<String, dynamic> _$GalleryToJson(Gallery instance) => <String, dynamic>{
  'id': instance.id,
  'storeId': instance.storeId,
  'position': instance.position,
  'gallery_name': instance.name,
  'gallery_description': instance.description,
  'gallery_type': _$GalleryTypeEnumMap[instance.type],
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'archivedAt': instance.archivedAt?.toIso8601String(),
};

const _$GalleryTypeEnumMap = {
  GalleryType.Store: 'Store',
  GalleryType.Product: 'Product',
  GalleryType.Publication: 'Publication',
};
