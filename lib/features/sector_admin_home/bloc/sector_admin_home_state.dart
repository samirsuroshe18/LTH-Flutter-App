part of 'sector_admin_home_bloc.dart';

@immutable
sealed class SectorAdminHomeState{}

final class SectorAdminHomeInitial extends SectorAdminHomeState{}

/// Get Dashboard overview
final class GetDashboardOverviewLoading extends SectorAdminHomeState{}

final class GetDashboardOverviewSuccess extends SectorAdminHomeState{
  final DashboardOverview response;
  GetDashboardOverviewSuccess({required this.response});
}

final class GetDashboardOverviewFailure extends SectorAdminHomeState{
  final String message;
  final int? status;

  GetDashboardOverviewFailure( {required this.message, this.status});
}
final class CreateWorkerLoading extends SectorAdminHomeState {}
final class CreateWorkerSuccess extends SectorAdminHomeState {
  final Technician technician;
  CreateWorkerSuccess({required this.technician});
}
final class CreateWorkerFailure extends SectorAdminHomeState {
  final String message;
  CreateWorkerFailure({required this.message});
}

final class GetWorkersListLoading extends SectorAdminHomeState {}
final class GetWorkersListSuccess extends SectorAdminHomeState {
  final List<Technician> workers;
  GetWorkersListSuccess({required this.workers});
}
final class GetWorkersListFailure extends SectorAdminHomeState {
  final String message;
  GetWorkersListFailure({required this.message});
}