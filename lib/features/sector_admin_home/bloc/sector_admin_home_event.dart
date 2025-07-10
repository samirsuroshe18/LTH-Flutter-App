// ignore_for_file: non_constant_identifier_names

part of 'sector_admin_home_bloc.dart';

@immutable
sealed class SectorAdminHomeEvent {}

final class GetDashboardOverview extends SectorAdminHomeEvent {}

final class CreateWorkerEvent extends SectorAdminHomeEvent {
  final String userName;
  final String email;
  final String phoneNo;
  final String technicianType;
  CreateWorkerEvent({
    required this.userName,
    required this.email,
    required this.phoneNo,
    required this.technicianType,
  });
}
final class GetWorkersListEvent extends SectorAdminHomeEvent {}