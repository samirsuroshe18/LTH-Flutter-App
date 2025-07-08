import 'dart:io';

import 'package:complaint_portal/features/technician_home/models/technician_model.dart';
import 'package:complaint_portal/features/technician_home/repository/technician_home_repository.dart';
import 'package:complaint_portal/utils/api_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'technician_home_event.dart';
part 'technician_home_state.dart';

class TechnicianHomeBloc extends Bloc<TechnicianHomeEvent, TechnicianHomeState> {
  final TechnicianHomeRepository _technicianRepository;

  TechnicianHomeBloc({required TechnicianHomeRepository technicianRepository})
    : _technicianRepository = technicianRepository,
      super(TechnicianHomeInitial()) {

    on<GetAssignComplaints>((event, emit) async {
      emit(GetAssignComplaintsLoading());
      try {
        final TechnicianModel response = await _technicianRepository.getAssignComplaints(queryParams: event.queryParams);
        emit(GetAssignComplaintsSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            GetAssignComplaintsFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(GetAssignComplaintsFailure(message: e.toString()));
        }
      }
    });

    on<StartWork>((event, emit) async {
      emit(StartWorkLoading());
      try {
        final AssignComplaint response = await _technicianRepository.startWork(complaintId: event.id);
        emit(StartWorkSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            StartWorkFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(StartWorkFailure(message: e.toString()));
        }
      }
    });

    on<AddComplaintResolution>((event, emit) async {
      emit(AddComplaintResolutionLoading());
      try{
        final AssignComplaint response = await _technicianRepository.addComplaintResolution(complaintId: event.complaintId, resolutionNote: event.resolutionNote, file: event.file);
        emit(AddComplaintResolutionSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AddComplaintResolutionFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AddComplaintResolutionFailure(message: e.toString()));
        }
      }
    });

  }
}
