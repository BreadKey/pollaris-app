// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'] as String,
    json['nickname'] as String,
    boolFromJson(json['isVerified'] as int),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'isVerified': instance.isVerified,
    };
