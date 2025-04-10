// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  id: json['id'] as String?,
  storeId: json['storeId'] as String?,
  productName: json['productName'] as String?,
  productDescription: json['productDescription'] as String?,
  productBasePrice: (json['productBasePrice'] as num?)?.toDouble(),
  productBaseCost: (json['productBaseCost'] as num?)?.toDouble(),
  productBaseQuantity: (json['productBaseQuantity'] as num?)?.toDouble(),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  archivedAt: json['archivedAt'] as String?,
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'storeId': instance.storeId,
  'productName': instance.productName,
  'productDescription': instance.productDescription,
  'productBasePrice': instance.productBasePrice,
  'productBaseCost': instance.productBaseCost,
  'productBaseQuantity': instance.productBaseQuantity,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'archivedAt': instance.archivedAt,
};
