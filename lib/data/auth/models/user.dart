import 'dart:convert';

import 'package:fitness_project/domain/entities/auth/user.dart';

class UserModel {
  final String userId;
  final String displayName;
  final String email;
  final String? image;
  final String description;

  UserModel(
      {required this.userId,
      required this.displayName,
      required this.email,
      this.image,
      required this.description});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'displayName': displayName,
      'email': email,
      'image': image,
      'description': description
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        userId: map['userId'] as String,
        displayName: map['displayName'] as String,
        email: map['email'] as String,
        image: map['image'] as String?,
        description: map['description'] as String);
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension UserXModel on UserModel {
  UserEntity toEntity() {
    return UserEntity(
        userId: userId,
        displayName: displayName,
        email: email,
        image: image,
        description: description);
  }
}
