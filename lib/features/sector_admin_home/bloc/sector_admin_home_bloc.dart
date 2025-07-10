import 'dart:io';

import 'package:complaint_portal/features/super_admin_home/models/dashboard_overview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:complaint_portal/features/auth/models/user_model.dart';
import '../models/technician_model.dart';
import '../../../utils/api_error.dart';
import '../repository/sector_admin_home_repository.dart';

part 'sector_admin_home_event.dart';
part 'sector_admin_home_state.dart';

class SectorAdminHomeBloc extends Bloc<SectorAdminHomeEvent, SectorAdminHomeState> {
  final SectorAdminHomeRepository _sectorAdminHomeRepository;

  SectorAdminHomeBloc({required SectorAdminHomeRepository sectorAdminHomeRepository})
    : _sectorAdminHomeRepository = sectorAdminHomeRepository,
      super(SectorAdminHomeInitial()) {

    on<GetDashboardOverview>((event, emit) async {
      emit(GetDashboardOverviewLoading());
      try {
        final DashboardOverview response = await _sectorAdminHomeRepository.getDashboardOverview();
        emit(GetDashboardOverviewSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            GetDashboardOverviewFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(GetDashboardOverviewFailure(message: e.toString()));
        }
      }
    });
    on<CreateWorkerEvent>((event, emit) async {
      emit(CreateWorkerLoading());
      try {
        final technician = await _sectorAdminHomeRepository.createTechnician(
          userName: event.userName,
          email: event.email,
          phoneNo: event.phoneNo,
          technicianType: event.technicianType,
        );
        emit(CreateWorkerSuccess(technician: technician));
      } catch (e) {
        if (e is ApiError) {
          emit(CreateWorkerFailure(message: e.message.toString()));
        } else {
          emit(CreateWorkerFailure(message: e.toString()));
        }
      }
    });
    on<GetWorkersListEvent>((event, emit) async {
      emit(GetWorkersListLoading());
      try {
        final workers = await _sectorAdminHomeRepository.getWorkersList();
        emit(GetWorkersListSuccess(workers: workers));
      } catch (e) {
        if (e is ApiError) {
          emit(GetWorkersListFailure(message: e.message.toString()));
        } else {
          emit(GetWorkersListFailure(message: e.toString()));
        }
      }
    });
  }
}
