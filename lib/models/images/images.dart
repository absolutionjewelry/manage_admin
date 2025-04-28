import 'package:json_annotation/json_annotation.dart';

part 'images.g.dart';

@JsonSerializable()
class Image {
  final String? id;
  final String? storeId;
  @JsonKey(name: 'image_content_type')
  final String? contentType;
  @JsonKey(name: 'image_content')
  final String? content;
  @JsonKey(name: 'image_name')
  final String? name;
  @JsonKey(name: 'image_description')
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? archivedAt;

  Image({
    this.id,
    this.storeId,
    this.contentType,
    this.content,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.archivedAt,
  });

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);

}