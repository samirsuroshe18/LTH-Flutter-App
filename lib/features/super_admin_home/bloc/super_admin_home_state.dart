part of 'super_admin_home_bloc.dart';

@immutable
sealed class SuperAdminHomeState{}

final class SuperAdminHomeInitial extends SuperAdminHomeState{}

/// Get Dashboard overview
final class GetDashboardOverviewLoading extends SuperAdminHomeState{}

final class GetDashboardOverviewSuccess extends SuperAdminHomeState{
  final DashboardOverview response;
  GetDashboardOverviewSuccess({required this.response});
}

final class GetDashboardOverviewFailure extends SuperAdminHomeState{
  final String message;
  final int? status;

  GetDashboardOverviewFailure( {required this.message, this.status});
}

/// Get Active Sectors
final class GetActiveSectorsLoading extends SuperAdminHomeState{}

final class GetActiveSectorsSuccess extends SuperAdminHomeState{
  final SectorModel response;
  GetActiveSectorsSuccess({required this.response});
}

final class GetActiveSectorsFailure extends SuperAdminHomeState{
  final String message;
  final int? status;

  GetActiveSectorsFailure( {required this.message, this.status});
}

/// Get Active Sectors
final class GetSectorAdminsLoading extends SuperAdminHomeState{}

final class GetSectorAdminsSuccess extends SuperAdminHomeState{
  final SectorAdminModel response;
  GetSectorAdminsSuccess({required this.response});
}

final class GetSectorAdminsFailure extends SuperAdminHomeState{
  final String message;
  final int? status;

  GetSectorAdminsFailure( {required this.message, this.status});
}

///remove admin
final class RemoveSectorAdminLoading extends SuperAdminHomeState{}

final class RemoveSectorAdminSuccess extends SuperAdminHomeState{
  final Map<String, dynamic> response;
  RemoveSectorAdminSuccess({required this.response});
}

final class RemoveSectorAdminFailure extends SuperAdminHomeState{
  final String message;
  final int? status;

  RemoveSectorAdminFailure( {required this.message, this.status});
}

///add sector admin
final class AddSectorAdminLoading extends SuperAdminHomeState{}

final class AddSectorAdminSuccess extends SuperAdminHomeState{
  final Map<String, dynamic> response;
  AddSectorAdminSuccess({required this.response});
}

final class AddSectorAdminFailure extends SuperAdminHomeState{
  final String message;
  final int? status;

  AddSectorAdminFailure( {required this.message, this.status});
}