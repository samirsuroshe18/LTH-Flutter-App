// To parse this JSON data, do
//
//     final adminComplaintModel = adminComplaintModelFromJson(jsonString);

import 'dart:convert';

AdminComplaintModel adminComplaintModelFromJson(String str) => AdminComplaintModel.fromJson(json.decode(str));

String adminComplaintModelToJson(AdminComplaintModel data) => json.encode(data.toJson());

class AdminComplaintModel {
  final List<AdminComplaint>? adminComplaints;
  final Pagination? pagination;

  AdminComplaintModel({
    this.adminComplaints,
    this.pagination,
  });

  factory AdminComplaintModel.fromJson(Map<String, dynamic> json) => AdminComplaintModel(
    adminComplaints: json["adminComplaints"] == null ? [] : List<AdminComplaint>.from(json["adminComplaints"]!.map((x) => AdminComplaint.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "adminComplaints": adminComplaints == null ? [] : List<dynamic>.from(adminComplaints!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class AdminComplaint {
  final String? id;
  final String? complaintId;
  final String? description;
  final String? image;
  final AdminComplaintLocation? location;
  final String? sector;
  final String? status;
  final String? assignStatus;
  final DateTime? assignedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final AssignedBy? assignedBy;
  final Resolution? resolution;
  final AssignedBy? assignedWorker;

  AdminComplaint({
    this.id,
    this.complaintId,
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

  factory AdminComplaint.fromJson(Map<String, dynamic> json) => AdminComplaint(
    id: json["_id"],
    complaintId: json["complaintId"],
    description: json["description"],
    image: json["image"],
    location: json["location"] == null ? null : AdminComplaintLocation.fromJson(json["location"]),
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

class AdminComplaintLocation {
  final String? id;
  final String? name;

  AdminComplaintLocation({
    this.id,
    this.name,
  });

  factory AdminComplaintLocation.fromJson(Map<String, dynamic> json) => AdminComplaintLocation(
    id: json["_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
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