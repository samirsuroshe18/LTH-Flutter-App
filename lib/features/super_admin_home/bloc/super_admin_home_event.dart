// ignore_for_file: non_constant_identifier_names

part of 'super_admin_home_bloc.dart';

@immutable
sealed class SuperAdminHomeEvent {}

final class GetDashboardOverview extends SuperAdminHomeEvent {}

final class GetActiveSectors extends SuperAdminHomeEvent {
  final Map<String, dynamic> queryParams;

  GetActiveSectors({required this.queryParams});
}

final class GetSupAdminComplaints extends SuperAdminHomeEvent {
  final Map<String, dynamic> queryParams;

  GetSupAdminComplaints({required this.queryParams});
}

final class GetSectorAdmins extends SuperAdminHomeEvent {
  final Map<String, dynamic> queryParams;

  GetSectorAdmins({required this.queryParams});
}

final class RemoveSectorAdmin extends SuperAdminHomeEvent{
  final String id;

  RemoveSectorAdmin({required this.id});
}

final class DeactivateSectorAdmin extends SuperAdminHomeEvent{
  final String id;

  DeactivateSectorAdmin({required this.id});
}

final class AddSectorAdmin extends SuperAdminHomeEvent{
  final String userName;
  final String email;
  final String phoneNo;
  final String password;
  final String sectorType;

  AddSectorAdmin({required this.userName, required this.email, required this.phoneNo, required this.password, required this.sectorType});
}

final class GetSupComplaintDetails extends SuperAdminHomeEvent {
  final String id;

  GetSupComplaintDetails({required this.id});
}

final class ApproveResolution extends SuperAdminHomeEvent {
  final String id;

  ApproveResolution({required this.id});
}

final class RejectResolution extends SuperAdminHomeEvent {
  final String resolutionId;
  final String rejectedNote;

  RejectResolution({required this.resolutionId, required this.rejectedNote});
}

final class GetSelectionTechnician extends SuperAdminHomeEvent {
  final String technicianType;

  GetSelectionTechnician({required this.technicianType});
}

final class AssignTechnician extends SuperAdminHomeEvent{
  final String complaintId;
  final String assignedWorker;

  AssignTechnician({required this.complaintId, required this.assignedWorker});
}

final class ReopenCompliant extends SuperAdminHomeEvent{
  final String complaintId;

  ReopenCompliant({required this.complaintId});
}

final class NoticeBoardCreateNotice extends SuperAdminHomeEvent{
  final String title;
  final String description;
  final File? file;

  NoticeBoardCreateNotice({required this.title, required this.description, this.file});
}

final class NoticeBoardGetAllNotices extends SuperAdminHomeEvent{
  final Map<String, dynamic> queryParams;

  NoticeBoardGetAllNotices({required this.queryParams});
}

final class NoticeBoardUpdateNotice extends SuperAdminHomeEvent{
  final String id;
  final String title;
  final String description;
  final File? file;
  final String? image;

  NoticeBoardUpdateNotice({required this.id, required this.title, required this.description, this.file, this.image});
}

final class NoticeBoardDeleteNotice extends SuperAdminHomeEvent{
  final String id;

  NoticeBoardDeleteNotice({required this.id});
}