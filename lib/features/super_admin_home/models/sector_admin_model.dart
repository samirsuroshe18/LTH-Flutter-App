// To parse this JSON data, do
//
//     final sectorAdminModel = sectorAdminModelFromJson(jsonString);

import 'dart:convert';

SectorAdminModel sectorAdminModelFromJson(String str) => SectorAdminModel.fromJson(json.decode(str));

String sectorAdminModelToJson(SectorAdminModel data) => json.encode(data.toJson());

class SectorAdminModel {
  final List<Sectoradmin>? sectoradmins;
  final Pagination? pagination;

  SectorAdminModel({
    this.sectoradmins,
    this.pagination,
  });

  factory SectorAdminModel.fromJson(Map<String, dynamic> json) => SectorAdminModel(
    sectoradmins: json["sectoradmins"] == null ? [] : List<Sectoradmin>.from(json["sectoradmins"]!.map((x) => Sectoradmin.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "sectoradmins": sectoradmins == null ? [] : List<dynamic>.from(sectoradmins!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Pagination {
  final int? totalEntries;
  final int? entriesPerPage;
  final int? currentPage;
  final int? totalPages;
  final bool? hasMore;

  Pagination({
    this.totalEntries,
    this.entriesPerPage,
    this.currentPage,
    this.totalPages,
    this.hasMore,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalEntries: json["totalEntries"],
    entriesPerPage: json["entriesPerPage"],
    currentPage: json["currentPage"],
    totalPages: json["totalPages"],
    hasMore: json["hasMore"],
  );

  Map<String, dynamic> toJson() => {
    "totalEntries": totalEntries,
    "entriesPerPage": entriesPerPage,
    "currentPage": currentPage,
    "totalPages": totalPages,
    "hasMore": hasMore,
  };
}

class Sectoradmin {
  final String? id;
  final String? userName;
  final String? phoneNo;
  final String? email;
  final String? role;
  final String? sectorType;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;

  Sectoradmin({
    this.id,
    this.userName,
    this.phoneNo,
    this.email,
    this.role,
    this.sectorType,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
  });

  factory Sectoradmin.fromJson(Map<String, dynamic> json) => Sectoradmin(
    id: json["_id"],
    userName: json["userName"],
    phoneNo: json["phoneNo"],
    email: json["email"],
    role: json["role"],
    sectorType: json["sectorType"],
    isActive: json["isActive"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    lastLogin: json["lastLogin"] == null ? null : DateTime.parse(json["lastLogin"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
    "phoneNo": phoneNo,
    "email": email,
    "role": role,
    "sectorType": sectorType,
    "isActive": isActive,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "lastLogin": lastLogin?.toIso8601String(),
  };
}
