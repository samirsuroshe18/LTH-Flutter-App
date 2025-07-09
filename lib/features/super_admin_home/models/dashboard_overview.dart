// To parse this JSON data, do
//
//     final dashboardOverview = dashboardOverviewFromJson(jsonString);

import 'dart:convert';

DashboardOverview dashboardOverviewFromJson(String str) => DashboardOverview.fromJson(json.decode(str));

String dashboardOverviewToJson(DashboardOverview data) => json.encode(data.toJson());

class DashboardOverview {
  final int? totalSectorAdmins;
  final int? pendingQueries;
  final int? resolvedQueries;
  final int? totalActiveSectors;

  DashboardOverview({
    this.totalSectorAdmins,
    this.pendingQueries,
    this.resolvedQueries,
    this.totalActiveSectors,
  });

  factory DashboardOverview.fromJson(Map<String, dynamic> json) => DashboardOverview(
    totalSectorAdmins: json["totalSectorAdmins"],
    pendingQueries: json["pendingQueries"],
    resolvedQueries: json["resolvedQueries"],
    totalActiveSectors: json["totalActiveSectors"],
  );

  Map<String, dynamic> toJson() => {
    "totalSectorAdmins": totalSectorAdmins,
    "pendingQueries": pendingQueries,
    "resolvedQueries": resolvedQueries,
    "totalActiveSectors": totalActiveSectors,
  };
}
