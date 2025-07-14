// To parse this JSON data, do
//
//     final dashboardOverview = dashboardOverviewFromJson(jsonString);

import 'dart:convert';

SectorDashboardOverview dashboardOverviewFromJson(String str) => SectorDashboardOverview.fromJson(json.decode(str));

String dashboardOverviewToJson(SectorDashboardOverview data) => json.encode(data.toJson());

class SectorDashboardOverview {
  final int? totalSectorAdmins;
  final int? totalTechnician;
  final int? pendingQueries;
  final int? resolvedQueries;
  final int? totalActiveSectors;
  final int? inProgressQueries;
  final int? rejectedQueries;

  SectorDashboardOverview({
    this.totalSectorAdmins,
    this.totalTechnician,
    this.pendingQueries,
    this.resolvedQueries,
    this.totalActiveSectors,
    this.inProgressQueries,
    this.rejectedQueries,
  });

  factory SectorDashboardOverview.fromJson(Map<String, dynamic> json) => SectorDashboardOverview(
    totalSectorAdmins: json["totalSectorAdmins"],
    totalTechnician: json["totalTechnician"],
    pendingQueries: json["pendingQueries"],
    resolvedQueries: json["resolvedQueries"],
    totalActiveSectors: json["totalActiveSectors"],
    inProgressQueries: json["inProgressQueries"],
    rejectedQueries: json["rejectedQueries"],
  );

  Map<String, dynamic> toJson() => {
    "totalSectorAdmins": totalSectorAdmins,
    "totalTechnician": totalTechnician,
    "pendingQueries": pendingQueries,
    "resolvedQueries": resolvedQueries,
    "totalActiveSectors": totalActiveSectors,
    "rejectedQueries": rejectedQueries,
    "inProgressQueries": inProgressQueries,
  };
}
