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
