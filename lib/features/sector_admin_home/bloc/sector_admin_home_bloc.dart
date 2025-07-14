import 'package:complaint_portal/features/sector_admin_home/models/sector_complaint_model.dart';
import 'package:complaint_portal/features/sector_admin_home/models/sector_dashboard_overview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    on<GetSectorDashboardOverview>((event, emit) async {
      emit(GetSectorDashboardOverviewLoading());
      try {
        final SectorDashboardOverview response = await _sectorAdminHomeRepository.getDashboardOverview();
        emit(GetSectorDashboardOverviewSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            GetSectorDashboardOverviewFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(GetSectorDashboardOverviewFailure(message: e.toString()));
        }
      }
    });

    on<GetSectorComplaints>((event, emit) async {
      emit(GetSectorComplaintsLoading());
      try {
        final SectorComplaintModel response = await _sectorAdminHomeRepository.getAllComplaints(queryParams: event.queryParams);
        emit(GetSectorComplaintsSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            GetSectorComplaintsFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(GetSectorComplaintsFailure(message: e.toString()));
        }
      }
    });

    on<GetSectorComplaintDetails>((event, emit) async {
      emit(GetSectorComplaintDetailsLoading());
      try {
        final SectorComplaint response = await _sectorAdminHomeRepository.getComplaintDetails(id: event.id);
        emit(GetSectorComplaintDetailsSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            GetSectorComplaintDetailsFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(GetSectorComplaintDetailsFailure(message: e.toString()));
        }
      }
    });

    on<CreateTechnician>((event, emit) async {
      emit(CreateTechnicianLoading());
      try {
        final Technician response = await _sectorAdminHomeRepository.createTechnician(userName: event.userName, email: event.email, phoneNo: event.phoneNo, technicianType: event.technicianType, password: event.password);
        emit(CreateTechnicianSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(CreateTechnicianFailure(message: e.message.toString(), status: e.statusCode,));
        } else {
          emit(CreateTechnicianFailure(message: e.toString()));
        }
      }
    });

    on<GetTechnician>((event, emit) async {
      emit(GetTechnicianLoading());
      try {
        final TechnicianModel response = await _sectorAdminHomeRepository.getTechnician();
        emit(GetTechnicianSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(GetTechnicianFailure(message: e.message.toString(), status: e.statusCode,));
        } else {
          emit(GetTechnicianFailure(message: e.toString()));
        }
      }
    });

    on<RemoveTechnician>((event, emit) async {
      emit(RemoveTechnicianLoading());
      try{
        final Map<String, dynamic> response = await _sectorAdminHomeRepository.removeTechnician(id: event.id);
        emit(RemoveTechnicianSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(RemoveTechnicianFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(RemoveTechnicianFailure(message: e.toString()));
        }
      }
    });

    on<ChangeTechnicianState>((event, emit) async {
      emit(ChangeTechnicianStateLoading());
      try{
        final Technician response = await _sectorAdminHomeRepository.changeTechnicianState(id: event.id);
        emit(ChangeTechnicianStateSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(ChangeTechnicianStateFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(ChangeTechnicianStateFailure(message: e.toString()));
        }
      }
    });

    on<GetSectorSelectionTechnician>((event, emit) async {
      emit(GetSectorSelectionTechnicianLoading());
      try {
        final List<Technician> response = await _sectorAdminHomeRepository.getSelectionTechnician(technicianType: event.technicianType);
        emit(GetSectorSelectionTechnicianSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            GetSectorSelectionTechnicianFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(GetSectorSelectionTechnicianFailure(message: e.toString()));
        }
      }
    });

    on<SectorAssignTechnician>((event, emit) async {
      emit(SectorAssignTechnicianLoading());
      try{
        final SectorComplaint response = await _sectorAdminHomeRepository.assignTechnician(complaintId: event.complaintId, assignedWorker: event.assignedWorker);
        emit(SectorAssignTechnicianSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(SectorAssignTechnicianFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(SectorAssignTechnicianFailure(message: e.toString()));
        }
      }
    });

    on<SectorApproveResolution>((event, emit) async {
      emit(SectorApproveResolutionLoading());
      try {
        final SectorComplaint response = await _sectorAdminHomeRepository.approveResolution(id: event.id);
        emit(SectorApproveResolutionSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            SectorApproveResolutionFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(SectorApproveResolutionFailure(message: e.toString()));
        }
      }
    });

    on<SectorRejectResolution>((event, emit) async {
      emit(SectorRejectResolutionLoading());
      try {
        final SectorComplaint response = await _sectorAdminHomeRepository.rejectResolution(resolutionId: event.resolutionId, rejectedNote: event.rejectedNote, );
        emit(SectorRejectResolutionSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            SectorRejectResolutionFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(SectorRejectResolutionFailure(message: e.toString()));
        }
      }
    });

    on<SectorReopenCompliant>((event, emit) async {
      emit(SectorReopenCompliantLoading());
      try{
        final SectorComplaint response = await _sectorAdminHomeRepository.reopenComplaint(complaintId: event.complaintId);
        emit(SectorReopenCompliantSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(SectorReopenCompliantFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(SectorReopenCompliantFailure(message: e.toString()));
        }
      }
    });
  }
}
