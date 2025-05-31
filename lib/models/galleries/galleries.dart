import 'package:json_annotation/json_annotation.dart';
part 'galleries.g.dart';

enum GalleryType {
    Store,
    Product,
    Publication,
    }

@JsonSerializable()
class Gallery {
  final String? id;
  final String? storeId;
  //TODO: put in gallery images model
  final String? position;
  @JsonKey(name: 'gallery_name')
  final String? name;
  @JsonKey(name: 'gallery_description')
  final String? description;
  @JsonKey(name: 'gallery_type')
  final GalleryType? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? archivedAt;
  @JsonKey(includeToJson: false, includeFromJson: false)
  final List<Image>? images;

  Gallery({
    this.id,
    this.storeId,
    this.position,
    this.name,
    this.description,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.archivedAt,
    this.images,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) => _$GalleryFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryToJson(this);
  
  Gallery copyWith({
    String? id,
    String? storeId,
    String? position,
    String? name,
    String? description,
    GalleryType? type,
    List<Image>? images,
  }) {
    return Gallery(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      position: position ?? this.position,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      images: images ?? this.images,
    );
  }
}