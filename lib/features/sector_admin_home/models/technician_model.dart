// To parse this JSON data, do
//
//     final sectorAdminModel = sectorAdminModelFromJson(jsonString);

import 'dart:convert';

TechnicianModel sectorAdminModelFromJson(String str) => TechnicianModel.fromJson(json.decode(str));

String sectorAdminModelToJson(TechnicianModel data) => json.encode(data.toJson());

class TechnicianModel {
  final List<Technician>? technician;
  final Pagination? pagination;

  TechnicianModel({
    this.technician,
    this.pagination,
  });

  factory TechnicianModel.fromJson(Map<String, dynamic> json) => TechnicianModel(
    technician: json["technician"] == null ? [] : List<Technician>.from(json["technician"]!.map((x) => Technician.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "technician": technician == null ? [] : List<dynamic>.from(technician!.map((x) => x.toJson())),
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

class Technician {
  final String? id;
  final String? userName;
  final String? phoneNo;
  final String? email;
  final String? role;
  final String? technicianType;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;

  Technician({
    this.id,
    this.userName,
    this.phoneNo,
    this.email,
    this.role,
    this.technicianType,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
  });

  factory Technician.fromJson(Map<String, dynamic> json) => Technician(
    id: json["_id"],
    userName: json["userName"],
    phoneNo: json["phoneNo"],
    email: json["email"],
    role: json["role"],
    technicianType: json["sectorType"],
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
    "sectorType": technicianType,
    "isActive": isActive,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "lastLogin": lastLogin?.toIso8601String(),
  };
}
