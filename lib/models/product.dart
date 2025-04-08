import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String productName;
  final String productDescription;
  final String productBasePrice;
  final String productBaseCost;
  final String productBaseQuantity;
  final String createdAt;
  final String updatedAt;
  final String archivedAt;

  Product({
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.productBasePrice,
    required this.productBaseCost,
    required this.productBaseQuantity,
    required this.createdAt,
    required this.updatedAt,
    required this.archivedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
