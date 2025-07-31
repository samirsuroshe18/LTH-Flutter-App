import 'dart:convert';
import 'dart:io';

import 'package:complaint_portal/constants/server_constant.dart';
import 'package:complaint_portal/features/technician_home/models/technician_complaint_model.dart';
import 'package:complaint_portal/utils/auth_http_client.dart';
import 'package:complaint_portal/utils/api_error.dart';
import 'package:http/http.dart' as http;

class TechnicianHomeRepository {

  Future<TechnicianComplaintModel> getAssignComplaints({ required final Map<String, dynamic> queryParams}) async {
    try {
      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/technician/get-assigned-complaints';
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
        return TechnicianComplaintModel.fromJson(jsonBody['data']);
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

  Future<AssignComplaint> startWork({ required final String complaintId}) async {
    try {
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/technician/start-work/$complaintId';

      final response = await AuthHttpClient.instance.get(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AssignComplaint.fromJson(jsonBody['data']);
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

  Future<AssignComplaint> addComplaintResolution({required String complaintId, required String resolutionNote, required File file}) async {
    try {
      final apiUrlFile = '${ServerConstant.baseUrl}/api/v1/technician/add-complaint-resolution';

      final fields = {
        'complaintId': complaintId,
        'resolutionNote': resolutionNote,
      };

      // Only create multipart file if file is not null
      List<http.MultipartFile> files = [];
      files.add(await http.MultipartFile.fromPath('file', file.path));

      // Use AuthHttpClient for multipart request
      final response = await AuthHttpClient.instance.multipartRequest(
        'POST',
        apiUrlFile,
        fields: fields,
        files: files,
      );

      // Handle the response
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AssignComplaint.fromJson(jsonBody['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode,
            message: jsonDecode(response.body)['message']);
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
