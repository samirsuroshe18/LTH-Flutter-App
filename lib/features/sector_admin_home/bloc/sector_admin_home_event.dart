// ignore_for_file: non_constant_identifier_names

part of 'sector_admin_home_bloc.dart';

@immutable
sealed class SectorAdminHomeEvent {}

final class GetDashboardOverview extends SectorAdminHomeEvent {}
