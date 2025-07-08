import 'dart:convert';
import 'dart:io';

import 'package:complaint_portal/constants/server_constant.dart';
import 'package:complaint_portal/features/technician_home/models/technician_model.dart';
import 'package:complaint_portal/utils/api_error.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:complaint_portal/features/auth/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TechnicianHomeRepository {

  Future<TechnicianModel> getAssignComplaints({ required final Map<String, dynamic> queryParams}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/technician/get-assigned-complaints';
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

  Future<AssignComplaint> startWork({ required final String complaintId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/technician/start-work/$complaintId';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final apiUrlFile = '${ServerConstant.baseUrl}/api/v1/technician/add-complaint-resolution';

      // Multipart request for both file and text fields
      var request = http.MultipartRequest('POST', Uri.parse(apiUrlFile))
        ..headers['Authorization'] = 'Bearer $accessToken';

      request.fields['complaintId'] = complaintId;
      request.fields['resolutionNote'] = resolutionNote;
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

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
