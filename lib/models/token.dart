import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  final String? value;
  final DateTime? expiresAt;
  final String? userId;

  Token({this.value, this.expiresAt, this.userId});

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);

  bool get isValid {
    if (value == null) return false;
    if (expiresAt == null) return false;
    if (expiresAt!.isBefore(DateTime.now())) return false;
    return true;
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    if (expiresAt!.isBefore(DateTime.now())) return true;
    return false;
  }
}
