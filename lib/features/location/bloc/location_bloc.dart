import 'package:complaint_portal/features/location/models/location_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/api_error.dart';
import '../repository/location_repository.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _locationRepository;

  LocationBloc({required LocationRepository locationRepository})
    : _locationRepository = locationRepository,
      super(LocationInitial()) {

    on<AddNewLocation>((event, emit) async {
      emit(AddNewLocationLoading());
      try {
        final Location response = await _locationRepository.addNewLocation(name: event.name, sectors: event.sectors);
        emit(AddNewLocationSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(AddNewLocationFailure(message: e.message.toString(), status: e.statusCode,));
        } else {
          emit(AddNewLocationFailure(message: e.toString()));
        }
      }
    });

    on<GetLocations>((event, emit) async {
      emit(GetLocationsLoading());
      try {
        final LocationModel response = await _locationRepository.getAllLocations(queryParams: event.queryParams);
        emit(GetLocationsSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            GetLocationsFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(GetLocationsFailure(message: e.toString()));
        }
      }
    });

    on<UpdateLocation>((event, emit) async {
      emit(UpdateLocationLoading());
      try {
        final Location response = await _locationRepository.updateLocation(id: event.id, name: event.name, sectors: event.sectors);
        emit(UpdateLocationSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            UpdateLocationFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(UpdateLocationFailure(message: e.toString()));
        }
      }
    });

    on<DeleteLocation>((event, emit) async {
      emit(DeleteLocationLoading());
      try {
        final Location response = await _locationRepository.deleteLocation(id: event.id);
        emit(DeleteLocationSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            DeleteLocationFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(DeleteLocationFailure(message: e.toString()));
        }
      }
    });
  }
}
