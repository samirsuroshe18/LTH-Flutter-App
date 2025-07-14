// ignore_for_file: non_constant_identifier_names

part of 'sector_admin_home_bloc.dart';

@immutable
sealed class SectorAdminHomeEvent {}

final class GetSectorDashboardOverview extends SectorAdminHomeEvent {}

final class GetSectorComplaints extends SectorAdminHomeEvent {
  final Map<String, dynamic> queryParams;

  GetSectorComplaints({required this.queryParams});
}

final class GetSectorComplaintDetails extends SectorAdminHomeEvent {
  final String id;

  GetSectorComplaintDetails({required this.id});
}

final class CreateTechnician extends SectorAdminHomeEvent {
  final String userName;
  final String email;
  final String phoneNo;
  final String technicianType;
  final String password;

  CreateTechnician({
    required this.userName,
    required this.email,
    required this.phoneNo,
    required this.technicianType,
    required this.password,
  });
}

final class GetTechnician extends SectorAdminHomeEvent {
  final Map<String, dynamic> queryParams;

  GetTechnician({required this.queryParams});
}

final class RemoveTechnician extends SectorAdminHomeEvent{
  final String id;

  RemoveTechnician({required this.id});
}

final class ChangeTechnicianState extends SectorAdminHomeEvent{
  final String id;

  ChangeTechnicianState({required this.id});
}

final class SectorApproveResolution extends SectorAdminHomeEvent {
  final String id;

  SectorApproveResolution({required this.id});
}

final class SectorRejectResolution extends SectorAdminHomeEvent {
  final String resolutionId;
  final String rejectedNote;

  SectorRejectResolution({required this.resolutionId, required this.rejectedNote});
}

final class GetSectorSelectionTechnician extends SectorAdminHomeEvent {
  final String technicianType;

  GetSectorSelectionTechnician({required this.technicianType});
}

final class SectorAssignTechnician extends SectorAdminHomeEvent {
  final String complaintId;
  final String assignedWorker;

  SectorAssignTechnician({required this.complaintId, required this.assignedWorker});
}

final class SectorReopenCompliant extends SectorAdminHomeEvent {
  final String complaintId;

  SectorReopenCompliant({required this.complaintId});
}