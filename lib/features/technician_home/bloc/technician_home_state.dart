part of 'technician_home_bloc.dart';

@immutable
sealed class TechnicianHomeState{}

final class TechnicianHomeInitial extends TechnicianHomeState{}

/// For Login State
final class GetAssignComplaintsLoading extends TechnicianHomeState{}

final class GetAssignComplaintsSuccess extends TechnicianHomeState{
  final TechnicianComplaintModel response;
  GetAssignComplaintsSuccess({required this.response});
}

final class GetAssignComplaintsFailure extends TechnicianHomeState{
  final String message;
  final int? status;

  GetAssignComplaintsFailure( {required this.message, this.status});
}

/// For Login State
final class StartWorkLoading extends TechnicianHomeState{}

final class StartWorkSuccess extends TechnicianHomeState{
  final AssignComplaint response;
  StartWorkSuccess({required this.response});
}

final class StartWorkFailure extends TechnicianHomeState{
  final String message;
  final int? status;

  StartWorkFailure( {required this.message, this.status});
}

/// Add complaint Resolution.
final class AddComplaintResolutionLoading extends TechnicianHomeState{}

final class AddComplaintResolutionSuccess extends TechnicianHomeState{
  final AssignComplaint response;
  AddComplaintResolutionSuccess({required this.response});
}

final class AddComplaintResolutionFailure extends TechnicianHomeState{
  final String message;
  final int? status;

  AddComplaintResolutionFailure( {required this.message, this.status});
}