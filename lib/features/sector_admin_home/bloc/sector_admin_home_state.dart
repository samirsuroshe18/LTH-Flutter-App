part of 'sector_admin_home_bloc.dart';

@immutable
sealed class SectorAdminHomeState{}

final class SectorAdminHomeInitial extends SectorAdminHomeState{}

/// Get Dashboard overview
final class GetSectorDashboardOverviewLoading extends SectorAdminHomeState{}

final class GetSectorDashboardOverviewSuccess extends SectorAdminHomeState{
  final SectorDashboardOverview response;
  GetSectorDashboardOverviewSuccess({required this.response});
}

final class GetSectorDashboardOverviewFailure extends SectorAdminHomeState{
  final String message;
  final int? status;

  GetSectorDashboardOverviewFailure( {required this.message, this.status});
}

/// Get All Complaints
final class GetSectorComplaintsLoading extends SectorAdminHomeState{}

final class GetSectorComplaintsSuccess extends SectorAdminHomeState{
  final SectorComplaintModel response;
  GetSectorComplaintsSuccess({required this.response});
}

final class GetSectorComplaintsFailure extends SectorAdminHomeState{
  final String message;
  final int? status;

  GetSectorComplaintsFailure( {required this.message, this.status});
}

/// Get Complaint Details
final class GetSectorComplaintDetailsLoading extends SectorAdminHomeState{}

final class GetSectorComplaintDetailsSuccess extends SectorAdminHomeState{
  final SectorComplaint response;
  GetSectorComplaintDetailsSuccess({required this.response});
}

final class GetSectorComplaintDetailsFailure extends SectorAdminHomeState{
  final String message;
  final int? status;

  GetSectorComplaintDetailsFailure( {required this.message, this.status});
}

/// Create Technician
final class CreateTechnicianLoading extends SectorAdminHomeState {}

final class CreateTechnicianSuccess extends SectorAdminHomeState {
  final Technician response;
  CreateTechnicianSuccess({required this.response});
}
final class CreateTechnicianFailure extends SectorAdminHomeState {
  final String message;
  final int? status;
  CreateTechnicianFailure({required this.message, this.status});
}

/// Get all Technicians
final class GetTechnicianLoading extends SectorAdminHomeState {}

final class GetTechnicianSuccess extends SectorAdminHomeState {
  final TechnicianModel response;
  GetTechnicianSuccess({required this.response});
}

final class GetTechnicianFailure extends SectorAdminHomeState {
  final String message;
  final int? status;
  GetTechnicianFailure({required this.message, this.status});
}

/// Remove technician
final class RemoveTechnicianLoading extends SectorAdminHomeState{}

final class RemoveTechnicianSuccess extends SectorAdminHomeState{
  final Map<String, dynamic> response;
  RemoveTechnicianSuccess({required this.response});
}

final class RemoveTechnicianFailure extends SectorAdminHomeState{
  final String message;
  final int? status;

  RemoveTechnicianFailure( {required this.message, this.status});
}

///Change Technician state
final class ChangeTechnicianStateLoading extends SectorAdminHomeState{}

final class ChangeTechnicianStateSuccess extends SectorAdminHomeState{
  final Technician response;
  ChangeTechnicianStateSuccess({required this.response});
}

final class ChangeTechnicianStateFailure extends SectorAdminHomeState{
  final String message;
  final int? status;

  ChangeTechnicianStateFailure( {required this.message, this.status});
}

/// Get Complaint Details
final class SectorApproveResolutionLoading extends SectorAdminHomeState{}

final class SectorApproveResolutionSuccess extends SectorAdminHomeState{
  final SectorComplaint response;
  SectorApproveResolutionSuccess({required this.response});
}

final class SectorApproveResolutionFailure extends SectorAdminHomeState{
  final String message;
  final int? status;

  SectorApproveResolutionFailure( {required this.message, this.status});
}

/// Get Complaint Details
final class SectorRejectResolutionLoading extends SectorAdminHomeState{}

final class SectorRejectResolutionSuccess extends SectorAdminHomeState{
  final SectorComplaint response;
  SectorRejectResolutionSuccess({required this.response});
}

final class SectorRejectResolutionFailure extends SectorAdminHomeState{
  final String message;
  final int? status;

  SectorRejectResolutionFailure( {required this.message, this.status});
}

/// Get Complaint Details
final class GetSectorSelectionTechnicianLoading extends SectorAdminHomeState{}

final class GetSectorSelectionTechnicianSuccess extends SectorAdminHomeState{
  final List<Technician> response;
  GetSectorSelectionTechnicianSuccess({required this.response});
}

final class GetSectorSelectionTechnicianFailure extends SectorAdminHomeState{
  final String message;
  final int? status;

  GetSectorSelectionTechnicianFailure( {required this.message, this.status});
}

///assign technician
final class SectorAssignTechnicianLoading extends SectorAdminHomeState{}

final class SectorAssignTechnicianSuccess extends SectorAdminHomeState{
  final SectorComplaint response;
  SectorAssignTechnicianSuccess({required this.response});
}

final class SectorAssignTechnicianFailure extends SectorAdminHomeState{
  final String message;
  final int? status;

  SectorAssignTechnicianFailure( {required this.message, this.status});
}

///assign technician
final class SectorReopenCompliantLoading extends SectorAdminHomeState{}

final class SectorReopenCompliantSuccess extends SectorAdminHomeState{
  final SectorComplaint response;
  SectorReopenCompliantSuccess({required this.response});
}

final class SectorReopenCompliantFailure extends SectorAdminHomeState{
  final String message;
  final int? status;

  SectorReopenCompliantFailure( {required this.message, this.status});
}