import 'package:json_annotation/json_annotation.dart';
import 'dart:developer';
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
    log('value: $value');
    log('expiresAt: $expiresAt');
    log('DateTime.now(): ${DateTime.now()}');
    log(
      'expiresAt!.isBefore(DateTime.now()): ${expiresAt!.isBefore(DateTime.now())}',
    );
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
