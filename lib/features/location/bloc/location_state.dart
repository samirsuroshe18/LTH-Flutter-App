part of 'location_bloc.dart';

@immutable
sealed class LocationState{}

final class LocationInitial extends LocationState{}

/// Add new Location
final class AddNewLocationLoading extends LocationState{}

final class AddNewLocationSuccess extends LocationState{
  final Location response;
  AddNewLocationSuccess({required this.response});
}

final class AddNewLocationFailure extends LocationState{
  final String message;
  final int? status;

  AddNewLocationFailure( {required this.message, this.status});
}

/// Get All Locations
final class GetLocationsLoading extends LocationState{}

final class GetLocationsSuccess extends LocationState{
  final LocationModel response;
  GetLocationsSuccess({required this.response});
}

final class GetLocationsFailure extends LocationState{
  final String message;
  final int? status;

  GetLocationsFailure( {required this.message, this.status});
}

/// Update Location
final class UpdateLocationLoading extends LocationState{}

final class UpdateLocationSuccess extends LocationState{
  final Location response;
  UpdateLocationSuccess({required this.response});
}

final class UpdateLocationFailure extends LocationState{
  final String message;
  final int? status;

  UpdateLocationFailure( {required this.message, this.status});
}

/// Delete Location
final class DeleteLocationLoading extends LocationState {}

final class DeleteLocationSuccess extends LocationState {
  final Location response;
  DeleteLocationSuccess({required this.response});
}

final class DeleteLocationFailure extends LocationState {
  final String message;
  final int? status;
  DeleteLocationFailure({required this.message, this.status});
}