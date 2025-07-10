import 'dart:io';

import 'package:complaint_portal/features/sector_admin_home/models/technician_model.dart';
import 'package:complaint_portal/features/super_admin_home/models/ActiveSectorMode.dart';
import 'package:complaint_portal/features/super_admin_home/models/AdminComplaintModel.dart';
import 'package:complaint_portal/features/super_admin_home/models/dashboard_overview.dart';
import 'package:complaint_portal/features/super_admin_home/models/sector_admin_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:complaint_portal/features/auth/models/user_model.dart';

import '../../../utils/api_error.dart';
import '../repository/super_admin_home_repository.dart';

part 'super_admin_home_event.dart';
part 'super_admin_home_state.dart';

class SuperAdminHomeBloc extends Bloc<SuperAdminHomeEvent, SuperAdminHomeState> {
  final SuperAdminHomeRepository _superAdminHomeRepository;

  SuperAdminHomeBloc({required SuperAdminHomeRepository superAdminHomeRepository})
    : _superAdminHomeRepository = superAdminHomeRepository,
      super(SuperAdminHomeInitial()) {

    on<GetDashboardOverview>((event, emit) async {
      emit(GetDashboardOverviewLoading());
      try {
        final DashboardOverview response = await _superAdminHomeRepository.getDashboardOverview();
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

    on<GetActiveSectors>((event, emit) async {
      emit(GetActiveSectorsLoading());
      try {
        final SectorModel response = await _superAdminHomeRepository.getActiveSectors(queryParams: event.queryParams);
        emit(GetActiveSectorsSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            GetActiveSectorsFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(GetActiveSectorsFailure(message: e.toString()));
        }
      }
    });

    on<GetSectorAdmins>((event, emit) async {
      emit(GetSectorAdminsLoading());
      try {
        final SectorAdminModel response = await _superAdminHomeRepository.getAllSectorAdmins(queryParams: event.queryParams);
        emit(GetSectorAdminsSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            GetSectorAdminsFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(GetSectorAdminsFailure(message: e.toString()));
        }
      }
    });

    on<GetAllComplaints>((event, emit) async {
      emit(GetAllComplaintsLoading());
      try {
        final AdminComplaintModel response = await _superAdminHomeRepository.getAllComplaints(queryParams: event.queryParams);
        emit(GetAllComplaintsSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            GetAllComplaintsFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(GetAllComplaintsFailure(message: e.toString()));
        }
      }
    });

    on<RemoveSectorAdmin>((event, emit) async {
      emit(RemoveSectorAdminLoading());
      try{
        final Map<String, dynamic> response = await _superAdminHomeRepository.removeSectorAdmin(id: event.id);
        emit(RemoveSectorAdminSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(RemoveSectorAdminFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(RemoveSectorAdminFailure(message: e.toString()));
        }
      }
    });

    on<AddSectorAdmin>((event, emit) async {
      emit(AddSectorAdminLoading());
      try{
        final Map<String, dynamic> response = await _superAdminHomeRepository.addSectorAdmin(userName: event.userName, email: event.email, phoneNo: event.phoneNo, password: event.password, sectorType: event.sectorType);
        emit(AddSectorAdminSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AddSectorAdminFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AddSectorAdminFailure(message: e.toString()));
        }
      }
    });

    on<GetComplaintDetails>((event, emit) async {
      emit(GetComplaintDetailsLoading());
      try {
        final AdminComplaint response = await _superAdminHomeRepository.getComplaintDetails(id: event.id);
        emit(GetComplaintDetailsSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            GetComplaintDetailsFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(GetComplaintDetailsFailure(message: e.toString()));
        }
      }
    });

    on<ApproveResolution>((event, emit) async {
      emit(ApproveResolutionLoading());
      try {
        final AdminComplaint response = await _superAdminHomeRepository.approveResolution(id: event.id);
        emit(ApproveResolutionSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            ApproveResolutionFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(ApproveResolutionFailure(message: e.toString()));
        }
      }
    });

    on<RejectResolution>((event, emit) async {
      emit(RejectResolutionLoading());
      try {
        final AdminComplaint response = await _superAdminHomeRepository.rejectResolution(resolutionId: event.resolutionId, rejectedNote: event.rejectedNote, );
        emit(RejectResolutionSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            RejectResolutionFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(RejectResolutionFailure(message: e.toString()));
        }
      }
    });

    on<GetSelectionTechnician>((event, emit) async {
      emit(GetSelectionTechnicianLoading());
      try {
        final List<Technician> response = await _superAdminHomeRepository.getSelectionTechnician(technicianType: event.technicianType);
        emit(GetSelectionTechnicianSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            GetSelectionTechnicianFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(GetSelectionTechnicianFailure(message: e.toString()));
        }
      }
    });

    on<AssignTechnician>((event, emit) async {
      emit(AssignTechnicianLoading());
      try{
        final AdminComplaint response = await _superAdminHomeRepository.assignTechnician(complaintId: event.complaintId, assignedWorker: event.assignedWorker);
        emit(AssignTechnicianSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AssignTechnicianFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AssignTechnicianFailure(message: e.toString()));
        }
      }
    });

    on<ReopenCompliant>((event, emit) async {
      emit(ReopenCompliantLoading());
      try{
        final AdminComplaint response = await _superAdminHomeRepository.reopenComplaint(complaintId: event.complaintId);
        emit(ReopenCompliantSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(ReopenCompliantFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(ReopenCompliantFailure(message: e.toString()));
        }
      }
    });
  }
}
