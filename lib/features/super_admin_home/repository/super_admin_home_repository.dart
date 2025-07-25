import 'dart:convert';
import 'dart:io';

import 'package:complaint_portal/constants/server_constant.dart';
import 'package:complaint_portal/features/sector_admin_home/models/technician_model.dart';
import 'package:complaint_portal/features/super_admin_home/models/active_sector_model.dart';
import 'package:complaint_portal/features/super_admin_home/models/admin_complaint_model.dart';
import 'package:complaint_portal/features/super_admin_home/models/dashboard_overview.dart';
import 'package:complaint_portal/features/super_admin_home/models/notice_board_model.dart';
import 'package:complaint_portal/features/super_admin_home/models/sector_admin_model.dart';
import 'package:complaint_portal/utils/api_error.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SuperAdminHomeRepository {

  Future<DashboardOverview> getDashboardOverview() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-dashboard-overview';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-complaints';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-active-sectors-grouped';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-sectoradmins';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final Map<String, dynamic> data = {
        'id': id,
      };

      const apiUrl =
          '${ServerConstant.baseUrl}/api/v1/admin/remove-sector-admin';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final Map<String, dynamic> data = {
        'id': id,
      };

      const apiUrl =
          '${ServerConstant.baseUrl}/api/v1/admin/deactivate-sector-admin';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
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

  Future<Map<String, dynamic>> addSectorAdmin({required String userName, required String email, required String phoneNo, required String password, required String sectorType,}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final Map<String, dynamic> payload = {
        'userName': userName,
        'email': email,
        'phoneNo': phoneNo,
        'password': password,
        'sectorType': sectorType,
      };

      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/create-sectoradmin';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
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

  Future<AdminComplaint> getComplaintDetails({required String id}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');


      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-admin-complaint-details/$id';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');


      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/approve-resolution/$id';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final payload = {
        'resolutionId': resolutionId,
        'rejectedNote': rejectedNote,
      };

      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/reject-resolution';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');


      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-technicians/$technicianType';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final Map<String, dynamic> data = {
        'complaintId': complaintId,
        'assignedWorker': assignedWorker,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/assigned-technician';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/reopen-complaint/$complaintId';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
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

  Future<Notice> createNotice({required String title, required String description, File? file}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    try {
      const apiUrlFile = '${ServerConstant.baseUrl}/api/v1/notice/create-notice';

      // Multipart request for both file and text fields
      var request = http.MultipartRequest('POST', Uri.parse(apiUrlFile))
        ..headers['Authorization'] = 'Bearer $accessToken';

      request.fields['title'] = title;
      request.fields['description'] = description;
      if (file != null)request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Handle the response
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return Notice.fromJson(jsonResponse['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode,
            message: jsonResponse['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<NoticeBoardModel> getAllNotices({ required Map<String, dynamic> queryParams}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/notice/get-notices';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return NoticeBoardModel.fromJson(jsonBody['data']);
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

  Future<Notice> updateNotice({required String id, required String title, required String description, File? file, String? image}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    try {
      final apiUrlFile =
          '${ServerConstant.baseUrl}/api/v1/notice/update-notice/$id';

      // Multipart request for both file and text fields
      var request = http.MultipartRequest('PUT', Uri.parse(apiUrlFile))
        ..headers['Authorization'] = 'Bearer $accessToken';

      request.fields['title'] = title;
      request.fields['description'] = description;
      if (image != null) request.fields['image'] = image;
      if (file != null) request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Handle the response
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

      if (response.statusCode == 200) {
        return Notice.fromJson(jsonResponse['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode,
            message: jsonResponse['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<Notice> deleteNotice({required String id}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final apiUrl =
          '${ServerConstant.baseUrl}/api/v1/notice/delete-notice/$id';
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Notice.fromJson(jsonBody['data']);
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
