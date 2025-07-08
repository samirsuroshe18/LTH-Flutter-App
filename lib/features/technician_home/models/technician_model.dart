// To parse this JSON data, do
//
//     final technicianModel = technicianModelFromJson(jsonString);

import 'dart:convert';

TechnicianModel technicianModelFromJson(String str) => TechnicianModel.fromJson(json.decode(str));

String technicianModelToJson(TechnicianModel data) => json.encode(data.toJson());

class TechnicianModel {
  final List<AssignComplaint>? assignComplaints;
  final Pagination? pagination;

  TechnicianModel({
    this.assignComplaints,
    this.pagination,
  });

  factory TechnicianModel.fromJson(Map<String, dynamic> json) => TechnicianModel(
    assignComplaints: json["assignComplaints"] == null ? [] : List<AssignComplaint>.from(json["assignComplaints"]!.map((x) => AssignComplaint.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "assignComplaints": assignComplaints == null ? [] : List<dynamic>.from(assignComplaints!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class AssignComplaint {
  final String? id;
  final String? complaintId;
  final String? category;
  final String? description;
  final String? image;
  final String? location;
  final String? sector;
  final String? status;
  final String? assignStatus;
  final DateTime? assignedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final AssignedBy? assignedBy;
  final Resolution? resolution;
  final AssignedBy? assignedWorker;

  AssignComplaint({
    this.id,
    this.complaintId,
    this.category,
    this.description,
    this.image,
    this.location,
    this.sector,
    this.status,
    this.assignStatus,
    this.assignedAt,
    this.createdAt,
    this.updatedAt,
    this.assignedBy,
    this.resolution,
    this.assignedWorker,
  });

  factory AssignComplaint.fromJson(Map<String, dynamic> json) => AssignComplaint(
    id: json["_id"],
    complaintId: json["complaintId"],
    category: json["category"],
    description: json["description"],
    image: json["image"],
    location: json["location"],
    sector: json["sector"],
    status: json["status"],
    assignStatus: json["assignStatus"],
    assignedAt: json["assignedAt"] == null ? null : DateTime.parse(json["assignedAt"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    assignedBy: json["assignedBy"] == null ? null : AssignedBy.fromJson(json["assignedBy"]),
    resolution: json["resolution"] == null ? null : Resolution.fromJson(json["resolution"]),
    assignedWorker: json["assignedWorker"] == null ? null : AssignedBy.fromJson(json["assignedWorker"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "complaintId": complaintId,
    "category": category,
    "description": description,
    "image": image,
    "location": location,
    "sector": sector,
    "status": status,
    "assignStatus": assignStatus,
    "assignedAt": assignedAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "assignedBy": assignedBy?.toJson(),
    "resolution": resolution?.toJson(),
    "assignedWorker": assignedWorker?.toJson(),
  };
}

class AssignedBy {
  final String? id;
  final String? userName;
  final String? phoneNo;
  final String? email;
  final String? role;

  AssignedBy({
    this.id,
    this.userName,
    this.phoneNo,
    this.email,
    this.role,
  });

  factory AssignedBy.fromJson(Map<String, dynamic> json) => AssignedBy(
    id: json["_id"],
    userName: json["userName"],
    phoneNo: json["phoneNo"],
    email: json["email"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
    "phoneNo": phoneNo,
    "email": email,
    "role": role,
  };
}

class Resolution {
  final String? id;
  final String? complaintId;
  final String? resolutionAttachment;
  final String? resolutionNote;
  final AssignedBy? resolvedBy;
  final DateTime? resolutionSubmittedAt;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Resolution({
    this.id,
    this.complaintId,
    this.resolutionAttachment,
    this.resolutionNote,
    this.resolvedBy,
    this.resolutionSubmittedAt,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Resolution.fromJson(Map<String, dynamic> json) => Resolution(
    id: json["_id"],
    complaintId: json["complaintId"],
    resolutionAttachment: json["resolutionAttachment"],
    resolutionNote: json["resolutionNote"],
    resolvedBy: json["resolvedBy"] == null ? null : AssignedBy.fromJson(json["resolvedBy"]),
    resolutionSubmittedAt: json["resolutionSubmittedAt"] == null ? null : DateTime.parse(json["resolutionSubmittedAt"]),
    status: json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "complaintId": complaintId,
    "resolutionAttachment": resolutionAttachment,
    "resolutionNote": resolutionNote,
    "resolvedBy": resolvedBy?.toJson(),
    "resolutionSubmittedAt": resolutionSubmittedAt?.toIso8601String(),
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
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
