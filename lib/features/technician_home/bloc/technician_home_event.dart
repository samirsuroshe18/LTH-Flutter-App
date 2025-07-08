// ignore_for_file: non_constant_identifier_names

part of 'technician_home_bloc.dart';

@immutable
sealed class TechnicianHomeEvent {}

final class GetAssignComplaints extends TechnicianHomeEvent {
  final Map<String, dynamic> queryParams;

  GetAssignComplaints({required this.queryParams});
}

final class StartWork extends TechnicianHomeEvent {
  final String id;

  StartWork({required this.id});
}

final class AddComplaintResolution extends TechnicianHomeEvent{
  final String complaintId;
  final String resolutionNote;
  final File file;
  AddComplaintResolution({required this.complaintId, required this.resolutionNote, required this.file});
}
