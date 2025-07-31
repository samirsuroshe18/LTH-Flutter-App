import 'dart:convert';

import 'package:complaint_portal/constants/server_constant.dart';
import 'package:complaint_portal/features/sector_admin_home/models/technician_model.dart';
import 'package:complaint_portal/features/super_admin_home/models/active_sector_model.dart';
import 'package:complaint_portal/features/super_admin_home/models/admin_complaint_model.dart';
import 'package:complaint_portal/features/super_admin_home/models/dashboard_overview.dart';
import 'package:complaint_portal/features/super_admin_home/models/sector_admin_model.dart';
import 'package:complaint_portal/utils/auth_http_client.dart';
import 'package:complaint_portal/utils/api_error.dart';

class SuperAdminHomeRepository {

  Future<DashboardOverview> getDashboardOverview() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-dashboard-overview';

      final response = await AuthHttpClient.instance.get(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return DashboardOverview.fromJson(jsonBody['data']);
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

  Future<AdminComplaintModel> getAllComplaints({required Map<String, dynamic> queryParams}) async {
    try {
      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-complaints';
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
        return AdminComplaintModel.fromJson(jsonBody['data']);
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

  Future<SectorModel> getActiveSectors({required Map<String, dynamic> queryParams}) async {
    try {
      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-active-sectors-grouped';
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
        return SectorModel.fromJson(jsonBody['data']);
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

  Future<SectorAdminModel> getAllSectorAdmins({required Map<String, dynamic> queryParams}) async {
    try {
      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-sectoradmins';
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
        return SectorAdminModel.fromJson(jsonBody['data']);
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

  Future<Map<String, dynamic>> removeSectorAdmin({required String id}) async {
    try {
      final Map<String, dynamic> data = {
        'id': id,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/remove-sector-admin';

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

  Future<Sectoradmin> deactivateSectorAdmin({required String id}) async {
    try {
      final Map<String, dynamic> data = {
        'id': id,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/deactivate-sector-admin';

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
        return Sectoradmin.fromJson(jsonBody['data']);
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

  Future<Sectoradmin> addSectorAdmin({required String userName, required String email, required String phoneNo, required String password, required String sectorType,}) async {
    try {
      final Map<String, dynamic> data = {
        'userName': userName,
        'email': email,
        'phoneNo': phoneNo,
        'password': password,
        'sectorType': sectorType,
      };

      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/create-sectoradmin';

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
        return Sectoradmin.fromJson(jsonBody['data']);
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

  Future<AdminComplaint> getComplaintDetails({required String id}) async {
    try {
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-admin-complaint-details/$id';

      final response = await AuthHttpClient.instance.get(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AdminComplaint.fromJson(jsonBody['data']);
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

  Future<AdminComplaint> approveResolution({required String id}) async {
    try {
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/approve-resolution/$id';

      final response = await AuthHttpClient.instance.get(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AdminComplaint.fromJson(jsonBody['data']);
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

  Future<AdminComplaint> rejectResolution({required String resolutionId, required String rejectedNote,}) async {
    try {
      final data = {
        'resolutionId': resolutionId,
        'rejectedNote': rejectedNote,
      };

      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/reject-resolution';

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
        return AdminComplaint.fromJson(jsonBody['data']);
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
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-selection-technician/$technicianType';

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

  Future<AdminComplaint> assignTechnician({required String complaintId, required String assignedWorker}) async {
    try {
      final Map<String, dynamic> data = {
        'complaintId': complaintId,
        'assignedWorker': assignedWorker,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/assigned-technician';

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
        return AdminComplaint.fromJson(jsonBody['data']);
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

  Future<AdminComplaint> reopenComplaint({required String complaintId}) async {
    try {
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/reopen-complaint/$complaintId';

      final response = await AuthHttpClient.instance.get(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AdminComplaint.fromJson(jsonBody['data']);
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
