import 'package:flutter/foundation.dart';

@immutable
class DataBaseUser {
  final String userId;
  final String email;
  final String userName;
  final String phoneNumber;

  const DataBaseUser({
    required this.userId,
    required this.userName,
    required this.phoneNumber,
    required this.email,
  });

  DataBaseUser.fromRow(Map<String, Object?> map)
      : userId = map["userId"] as String,
        email = map["email"] as String,
        userName = map["username"] as String,
        phoneNumber = map["phone_number"] as String;

  @override
  String toString() => 'Persons id : $userId , Persons email : $email';

  @override
  bool operator ==(covariant DataBaseUser other) => userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}
