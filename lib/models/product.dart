import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String? id;
  final String? storeId;
  final String? productName;
  final String? productDescription;
  final double? productBasePrice;
  final double? productBaseCost;
  final double? productBaseQuantity;
  final String? createdAt;
  final String? updatedAt;
  final String? archivedAt;

  Product({
    this.id,
    this.storeId,
    this.productName,
    this.productDescription,
    this.productBasePrice,
    this.productBaseCost,
    this.productBaseQuantity,
    this.createdAt,
    this.updatedAt,
    this.archivedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    String? productName,
    String? productDescription,
    double? productBasePrice,
    double? productBaseCost,
    double? productBaseQuantity,
  }) {
    return Product(
      id: id,
      storeId: storeId,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      productBasePrice: productBasePrice ?? this.productBasePrice,
      productBaseCost: productBaseCost ?? this.productBaseCost,
      productBaseQuantity: productBaseQuantity ?? this.productBaseQuantity,
      createdAt: createdAt,
      updatedAt: updatedAt,
      archivedAt: archivedAt,
    );
  }
}
