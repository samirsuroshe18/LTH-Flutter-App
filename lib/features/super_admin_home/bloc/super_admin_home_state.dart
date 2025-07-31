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

/// Get All Complaints
final class GetSupAdminComplaintsLoading extends SuperAdminHomeState{}

final class GetSupAdminComplaintsSuccess extends SuperAdminHomeState{
  final AdminComplaintModel response;
  GetSupAdminComplaintsSuccess({required this.response});
}

final class GetSupAdminComplaintsFailure extends SuperAdminHomeState{
  final String message;
  final int? status;

  GetSupAdminComplaintsFailure( {required this.message, this.status});
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

///Deactivate admin
final class DeactivateSectorAdminLoading extends SuperAdminHomeState{}

final class DeactivateSectorAdminSuccess extends SuperAdminHomeState{
  final Sectoradmin response;
  DeactivateSectorAdminSuccess({required this.response});
}

final class DeactivateSectorAdminFailure extends SuperAdminHomeState{
  final String message;
  final int? status;

  DeactivateSectorAdminFailure( {required this.message, this.status});
}

///add sector admin
final class AddSectorAdminLoading extends SuperAdminHomeState{}

final class AddSectorAdminSuccess extends SuperAdminHomeState{
  final Sectoradmin response;
  AddSectorAdminSuccess({required this.response});
}

final class AddSectorAdminFailure extends SuperAdminHomeState{
  final String message;
  final int? status;

  AddSectorAdminFailure( {required this.message, this.status});
}

/// Get Complaint Details
final class GetSupComplaintDetailsLoading extends SuperAdminHomeState{}

final class GetSupComplaintDetailsSuccess extends SuperAdminHomeState{
  final AdminComplaint response;
  GetSupComplaintDetailsSuccess({required this.response});
}

final class GetSupComplaintDetailsFailure extends SuperAdminHomeState{
  final String message;
  final int? status;

  GetSupComplaintDetailsFailure( {required this.message, this.status});
}

/// Get Complaint Details
final class ApproveResolutionLoading extends SuperAdminHomeState{}

final class ApproveResolutionSuccess extends SuperAdminHomeState{
  final AdminComplaint response;
  ApproveResolutionSuccess({required this.response});
}

final class ApproveResolutionFailure extends SuperAdminHomeState{
  final String message;
  final int? status;

  ApproveResolutionFailure( {required this.message, this.status});
}

/// Get Complaint Details
final class RejectResolutionLoading extends SuperAdminHomeState{}

final class RejectResolutionSuccess extends SuperAdminHomeState{
  final AdminComplaint response;
  RejectResolutionSuccess({required this.response});
}

final class RejectResolutionFailure extends SuperAdminHomeState{
  final String message;
  final int? status;

  RejectResolutionFailure( {required this.message, this.status});
}

/// Get Complaint Details
final class GetSelectionTechnicianLoading extends SuperAdminHomeState{}

final class GetSelectionTechnicianSuccess extends SuperAdminHomeState{
  final List<Technician> response;
  GetSelectionTechnicianSuccess({required this.response});
}

final class GetSelectionTechnicianFailure extends SuperAdminHomeState{
  final String message;
  final int? status;

  GetSelectionTechnicianFailure( {required this.message, this.status});
}

///assign technician
final class AssignTechnicianLoading extends SuperAdminHomeState{}

final class AssignTechnicianSuccess extends SuperAdminHomeState{
  final AdminComplaint response;
  AssignTechnicianSuccess({required this.response});
}

final class AssignTechnicianFailure extends SuperAdminHomeState{
  final String message;
  final int? status;

  AssignTechnicianFailure( {required this.message, this.status});
}

///assign technician
final class ReopenCompliantLoading extends SuperAdminHomeState{}

final class ReopenCompliantSuccess extends SuperAdminHomeState{
  final AdminComplaint response;
  ReopenCompliantSuccess({required this.response});
}

final class ReopenCompliantFailure extends SuperAdminHomeState{
  final String message;
  final int? status;

  ReopenCompliantFailure( {required this.message, this.status});
}