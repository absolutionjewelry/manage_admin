import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

@JsonSerializable()
class Store {
  final String? id;
  final String? storeName;
  final String? storeDescription;

  Store({
    required this.id,
    required this.storeName,
    required this.storeDescription,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
