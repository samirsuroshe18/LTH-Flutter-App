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
  final String? phoneNo;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;
  final bool? isLoggedIn;
  final String? fcmToken;
  final String? technicianType;
  final String? sectorType;
  final DateTime? lastLogout;

  UserModel({
    this.id,
    this.userName,
    this.email,
    this.role,
    this.phoneNo,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
    this.isLoggedIn,
    this.fcmToken,
    this.technicianType,
    this.sectorType,
    this.lastLogout,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["_id"],
    userName: json["userName"],
    email: json["email"],
    role: json["role"],
    phoneNo: json["phoneNo"],
    isActive: json["isActive"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    lastLogin: json["lastLogin"] == null ? null : DateTime.parse(json["lastLogin"]),
    isLoggedIn: json["isLoggedIn"],
    fcmToken: json["FCMToken"],
    technicianType: json["technicianType"],
    sectorType: json["sectorType"],
    lastLogout: json["lastLogout"] == null ? null : DateTime.parse(json["lastLogout"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
    "email": email,
    "role": role,
    "phoneNo": phoneNo,
    "isActive": isActive,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "lastLogin": lastLogin?.toIso8601String(),
    "isLoggedIn": isLoggedIn,
    "FCMToken": fcmToken,
    "technicianType": technicianType,
    "sectorType": sectorType,
    "lastLogout": lastLogout?.toIso8601String(),
  };
}
