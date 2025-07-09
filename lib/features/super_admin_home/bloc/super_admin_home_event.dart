// ignore_for_file: non_constant_identifier_names

part of 'super_admin_home_bloc.dart';

@immutable
sealed class SuperAdminHomeEvent {}

final class GetDashboardOverview extends SuperAdminHomeEvent {}

final class GetActiveSectors extends SuperAdminHomeEvent {
  final Map<String, dynamic> queryParams;

  GetActiveSectors({required this.queryParams});
}

final class GetSectorAdmins extends SuperAdminHomeEvent {
  final Map<String, dynamic> queryParams;

  GetSectorAdmins({required this.queryParams});
}

final class RemoveSectorAdmin extends SuperAdminHomeEvent{
  final String id;

  RemoveSectorAdmin({required this.id});
}

final class AddSectorAdmin extends SuperAdminHomeEvent{
  final String userName;
  final String email;
  final String phoneNo;
  final String password;
  final String sectorType;

  AddSectorAdmin({required this.userName, required this.email, required this.phoneNo, required this.password, required this.sectorType});
}
