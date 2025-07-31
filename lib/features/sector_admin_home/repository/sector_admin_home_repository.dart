import 'dart:convert';

import 'package:complaint_portal/constants/server_constant.dart';
import 'package:complaint_portal/features/sector_admin_home/models/sector_complaint_model.dart';
import 'package:complaint_portal/features/sector_admin_home/models/sector_dashboard_overview.dart';
import 'package:complaint_portal/utils/auth_http_client.dart';
import 'package:complaint_portal/utils/api_error.dart';
import '../models/technician_model.dart';
class SectorAdminHomeRepository {

  Future<SectorDashboardOverview> getDashboardOverview() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/sectoradmin/get-sector-dashboard-overview';

      final response = await AuthHttpClient.instance.get(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return SectorDashboardOverview.fromJson(jsonBody['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode, message: jsonBody['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<SectorComplaintModel> getAllComplaints({required Map<String, dynamic> queryParams}) async {
    try {
      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/sectoradmin/get-sector-complaints';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }

      final response = await AuthHttpClient.instance.get(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return SectorComplaintModel.fromJson(jsonBody['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode, message: jsonBody['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<SectorComplaint> getComplaintDetails({required String id}) async {
    try {
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/sectoradmin/get-sector-complaint-details/$id';

      final response = await AuthHttpClient.instance.get(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return SectorComplaint.fromJson(jsonBody['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode, message: jsonBody['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<Technician> createTechnician({required String userName, required String email, required String phoneNo, required String technicianType, required String password,}) async {
    try {
      final payload = {
        'userName': userName,
        'email': email,
        'phoneNo': phoneNo,
        'password': password,
        'technicianType': technicianType,
      };

      final apiUrl = '${ServerConstant.baseUrl}/api/v1/sectoradmin/create-technician';

      final response = await AuthHttpClient.instance.post(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(payload),
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Technician.fromJson(jsonBody['data']);
      } else {
        throw ApiError(statusCode: response.statusCode, message: jsonBody['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<TechnicianModel> getTechnician({required Map<String, dynamic> queryParams}) async {
    try {
      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/sectoradmin/get-technician';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }

      final response = await AuthHttpClient.instance.get(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return TechnicianModel.fromJson(jsonBody['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode, message: jsonBody['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<Map<String, dynamic>> removeTechnician({required String id}) async {
    try {
      final Map<String, dynamic> data = {
        'id': id,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/sectoradmin/remove-technician';

      final response = await AuthHttpClient.instance.post(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonBody;
      } else {
        throw ApiError(
            statusCode: response.statusCode, message: jsonBody['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<Technician> changeTechnicianState({required String id}) async {
    try {
      final Map<String, dynamic> data = {
        'id': id,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/sectoradmin/change-technician-state';

      final response = await AuthHttpClient.instance.post(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Technician.fromJson(jsonBody['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode, message: jsonBody['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<SectorComplaint> approveResolution({required String id}) async {
    try {
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/sectoradmin/approve-resolution/$id';

      final response = await AuthHttpClient.instance.get(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return SectorComplaint.fromJson(jsonBody['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode, message: jsonBody['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<SectorComplaint> rejectResolution({required String resolutionId, required String rejectedNote,}) async {
    try {
      final data = {
        'resolutionId': resolutionId,
        'rejectedNote': rejectedNote,
      };

      String apiUrl = '${ServerConstant.baseUrl}/api/v1/sectoradmin/reject-resolution';

      final response = await AuthHttpClient.instance.post(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return SectorComplaint.fromJson(jsonBody['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode, message: jsonBody['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<List<Technician>> getSelectionTechnician({required String technicianType}) async {
    try {
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/sectoradmin/get-selection-technician/$technicianType';

      final response = await AuthHttpClient.instance.get(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return (jsonBody['data'] as List)
            .map((data) => Technician.fromJson(data))
            .toList();
      } else {
        throw ApiError(
            statusCode: response.statusCode, message: jsonBody['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<SectorComplaint> assignTechnician({required String complaintId, required String assignedWorker}) async {
    try {
      final Map<String, dynamic> data = {
        'complaintId': complaintId,
        'assignedWorker': assignedWorker,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/sectoradmin/assign-technician';

      final response = await AuthHttpClient.instance.post(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return SectorComplaint.fromJson(jsonBody['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode, message: jsonBody['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<SectorComplaint> reopenComplaint({required String complaintId}) async {
    try {
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/sectoradmin/reopen-complaint/$complaintId';

      final response = await AuthHttpClient.instance.get(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return SectorComplaint.fromJson(jsonBody['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode, message: jsonBody['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }
}
