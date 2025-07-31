// To parse this JSON data, do
//
//     final adminComplaintModel = adminComplaintModelFromJson(jsonString);

import 'dart:convert';

SectorComplaintModel adminComplaintModelFromJson(String str) => SectorComplaintModel.fromJson(json.decode(str));

String adminComplaintModelToJson(SectorComplaintModel data) => json.encode(data.toJson());

class SectorComplaintModel {
  final List<SectorComplaint>? sectorComplaints;
  final Pagination? pagination;

  SectorComplaintModel({
    this.sectorComplaints,
    this.pagination,
  });

  factory SectorComplaintModel.fromJson(Map<String, dynamic> json) => SectorComplaintModel(
    sectorComplaints: json["complaints"] == null ? [] : List<SectorComplaint>.from(json["complaints"]!.map((x) => SectorComplaint.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "complaints": sectorComplaints == null ? [] : List<dynamic>.from(sectorComplaints!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class SectorComplaint {
  final String? id;
  final String? complaintId;
  final String? category;
  final String? description;
  final String? image;
  final SectorComplaintLocation? location;
  final String? sector;
  final String? status;
  final String? assignStatus;
  final DateTime? assignedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final AssignedBy? assignedBy;
  final Resolution? resolution;
  final AssignedBy? assignedWorker;

  SectorComplaint({
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

  factory SectorComplaint.fromJson(Map<String, dynamic> json) => SectorComplaint(
    id: json["_id"],
    complaintId: json["complaintId"],
    category: json["category"],
    description: json["description"],
    image: json["image"],
    location: json["location"] == null ? null : SectorComplaintLocation.fromJson(json["location"]),
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
    "location": location?.toJson(),
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

class SectorComplaintLocation {
  final String? id;
  final String? name;

  SectorComplaintLocation({
    this.id,
    this.name,
  });

  factory SectorComplaintLocation.fromJson(Map<String, dynamic> json) => SectorComplaintLocation(
    id: json["_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
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
  final AssignedBy? approvedBy;

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
    this.approvedBy,
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
    approvedBy: json["approvedBy"] == null ? null : AssignedBy.fromJson(json["approvedBy"]),
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
    "approvedBy": approvedBy?.toJson(),
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