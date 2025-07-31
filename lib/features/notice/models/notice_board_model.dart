// To parse this JSON data, do
//
//     final noticeBoardModel = noticeBoardModelFromJson(jsonString);

import 'dart:convert';

NoticeBoardModel noticeBoardModelFromJson(String str) => NoticeBoardModel.fromJson(json.decode(str));

String noticeBoardModelToJson(NoticeBoardModel data) => json.encode(data.toJson());

class NoticeBoardModel {
  final List<Notice>? notices;
  final Pagination? pagination;

  NoticeBoardModel({
    this.notices,
    this.pagination,
  });

  factory NoticeBoardModel.fromJson(Map<String, dynamic> json) => NoticeBoardModel(
    notices: json["notices"] == null ? [] : List<Notice>.from(json["notices"]!.map((x) => Notice.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "notices": notices == null ? [] : List<dynamic>.from(notices!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Notice {
  final String? id;
  final String? title;
  final String? description;
  final String? image;
  final bool? isDeleted;
  final By? createdBy;
  final By? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Notice({
    this.id,
    this.title,
    this.description,
    this.image,
    this.isDeleted,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    isDeleted: json["isDeleted"],
    createdBy: json["createdBy"] == null ? null : By.fromJson(json["createdBy"]),
    updatedBy: json["updatedBy"] == null ? null : By.fromJson(json["updatedBy"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "image": image,
    "isDeleted": isDeleted,
    "createdBy": createdBy?.toJson(),
    "updatedBy": updatedBy?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class By {
  final String? id;
  final String? userName;
  final String? email;

  By({
    this.id,
    this.userName,
    this.email,
  });

  factory By.fromJson(Map<String, dynamic> json) => By(
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
