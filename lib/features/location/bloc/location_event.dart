// ignore_for_file: non_constant_identifier_names

part of 'location_bloc.dart';

@immutable
sealed class LocationEvent {}

final class AddNewLocation extends LocationEvent {
  final String name;
  final List<String> sectors;

  AddNewLocation({
    required this.name,
    required this.sectors,
  });
}

final class GetLocations extends LocationEvent {
  final Map<String, dynamic> queryParams;
  GetLocations({required this.queryParams});
}

final class UpdateLocation extends LocationEvent {
  final String id;
  final String name;
  final List<String> sectors;

  UpdateLocation({required this.id, required this.name, required this.sectors});
}

final class DeleteLocation extends LocationEvent {
  final String id;

  DeleteLocation({required this.id});
}