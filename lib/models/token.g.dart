// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
  value: json['value'] as String?,
  expiresAt:
      json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
  'value': instance.value,
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'userId': instance.userId,
};
