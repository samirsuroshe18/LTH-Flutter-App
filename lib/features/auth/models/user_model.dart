// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String? id;
  final String? userName;
  final String? email;
  final String? role;
  final bool? isActive;
  final DateTime? lastLogin;

  UserModel({
    this.id,
    this.userName,
    this.email,
    this.role,
    this.isActive,
    this.lastLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["_id"],
    userName: json["userName"],
    email: json["email"],
    role: json["role"],
    isActive: json["isActive"],
    lastLogin: json["lastLogin"] == null ? null : DateTime.parse(json["lastLogin"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
    "email": email,
    "role": role,
    "isActive": isActive,
    "lastLogin": lastLogin?.toIso8601String(),
  };
}