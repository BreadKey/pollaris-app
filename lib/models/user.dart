import 'package:json_annotation/json_annotation.dart';
import 'package:pollaris_app/models/utils.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  String nickname;
  @JsonKey(fromJson: boolFromJson)
  bool isVerified;

  User(this.id, this.nickname, this.isVerified);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
