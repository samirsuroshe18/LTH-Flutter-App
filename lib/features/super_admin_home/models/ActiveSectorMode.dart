// To parse this JSON data, do
//
//     final sectorModel = sectorModelFromJson(jsonString);

import 'dart:convert';

SectorModel sectorModelFromJson(String str) => SectorModel.fromJson(json.decode(str));

String sectorModelToJson(SectorModel data) => json.encode(data.toJson());

class SectorModel {
  final List<ActiveSectorModel>? activeSectorModel;
  final Pagination? pagination;

  SectorModel({
    this.activeSectorModel,
    this.pagination,
  });

  factory SectorModel.fromJson(Map<String, dynamic> json) => SectorModel(
    activeSectorModel: json["ActiveSectorModel"] == null ? [] : List<ActiveSectorModel>.from(json["ActiveSectorModel"]!.map((x) => ActiveSectorModel.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "ActiveSectorModel": activeSectorModel == null ? [] : List<dynamic>.from(activeSectorModel!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class ActiveSectorModel {
  final String? sectorName;
  final List<Admin>? admins;
  final int? totalCount;
  final int? pendingCount;
  final DateTime? lastUpdated;

  ActiveSectorModel({
    this.sectorName,
    this.admins,
    this.totalCount,
    this.pendingCount,
    this.lastUpdated,
  });

  factory ActiveSectorModel.fromJson(Map<String, dynamic> json) => ActiveSectorModel(
    sectorName: json["sectorName"],
    admins: json["admins"] == null ? [] : List<Admin>.from(json["admins"]!.map((x) => Admin.fromJson(x))),
    totalCount: json["totalCount"],
    pendingCount: json["pendingCount"],
    lastUpdated: json["lastUpdated"] == null ? null : DateTime.parse(json["lastUpdated"]),
  );

  Map<String, dynamic> toJson() => {
    "sectorName": sectorName,
    "admins": admins == null ? [] : List<dynamic>.from(admins!.map((x) => x.toJson())),
    "totalCount": totalCount,
    "pendingCount": pendingCount,
    "lastUpdated": lastUpdated?.toIso8601String(),
  };
}

class Admin {
  final String? id;
  final String? name;
  final String? email;

  Admin({
    this.id,
    this.name,
    this.email,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    id: json["id"],
    name: json["name"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
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