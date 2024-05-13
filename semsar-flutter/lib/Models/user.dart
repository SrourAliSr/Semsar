import 'package:json_annotation/json_annotation.dart';

part "user.g.dart";

@JsonSerializable()
class User {
  final String userId;

  final String email;

  final String userName;

  final String phoneNumber;

  User({
    required this.userId,
    required this.email,
    required this.userName,
    required this.phoneNumber,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
