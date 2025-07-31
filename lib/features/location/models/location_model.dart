// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  final List<Location>? locations;
  final Pagination? pagination;

  LocationModel({
    this.locations,
    this.pagination,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    locations: json["locations"] == null ? [] : List<Location>.from(json["locations"]!.map((x) => Location.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "locations": locations == null ? [] : List<dynamic>.from(locations!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Location {
  final String? id;
  final String? name;
  final int? locationId;
  final List<String>? sectors;
  final String? qrCode;
  final bool? isDeleted;
  final DeletedAt? deletedBy;
  final DeletedAt? updatedBy;
  final DeletedAt? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Location({
    this.id,
    this.name,
    this.locationId,
    this.sectors,
    this.qrCode,
    this.isDeleted,
    this.deletedBy,
    this.updatedBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["_id"],
    name: json["name"],
    locationId: json["locationId"],
    sectors: json["sectors"] == null ? [] : List<String>.from(json["sectors"]!.map((x) => x)),
    qrCode: json["qrCode"],
    isDeleted: json["isDeleted"],
    deletedBy: json["deletedBy"] == null ? null : DeletedAt.fromJson(json["deletedBy"]),
    updatedBy: json["updatedBy"] == null ? null : DeletedAt.fromJson(json["updatedBy"]),
    deletedAt: json["deletedAt"] == null ? null : DeletedAt.fromJson(json["deletedAt"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "locationId": locationId,
    "sectors": sectors == null ? [] : List<dynamic>.from(sectors!.map((x) => x)),
    "qrCode": qrCode,
    "isDeleted": isDeleted,
    "deletedBy": deletedBy?.toJson(),
    "updatedBy": updatedBy?.toJson(),
    "deletedAt": deletedAt?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class DeletedAt {
  final String? id;
  final String? userName;
  final String? email;

  DeletedAt({
    this.id,
    this.userName,
    this.email,
  });

  factory DeletedAt.fromJson(Map<String, dynamic> json) => DeletedAt(
    id: json["_id"],
    userName: json["userName"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
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