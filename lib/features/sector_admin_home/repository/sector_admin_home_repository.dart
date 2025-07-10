import 'dart:convert';

import 'package:complaint_portal/constants/server_constant.dart';
import 'package:complaint_portal/features/super_admin_home/models/dashboard_overview.dart';
import 'package:complaint_portal/utils/api_error.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:complaint_portal/features/auth/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/technician_model.dart';
class SectorAdminHomeRepository {

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
  Future<Technician> createTechnician({
    required String userName,
    required String email,
    required String phoneNo,
    required String technicianType,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      final apiUrl = '${ServerConstant.baseUrl}/api/v1/sectoradmin/create-technician';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'userName': userName,
          'email': email,
          'phoneNo': phoneNo,
          'technicianType': technicianType,
        }),
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
  Future<List<Technician>> getWorkersList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      final apiUrl = '${ServerConstant.baseUrl}/api/v1/sectoradmin/get-technician';
      print('Token: $accessToken');
      print('Headers: ${{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      }}');
      print('URL: $apiUrl');

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> workersData = jsonBody['data'];
        return workersData.map((json) => Technician.fromJson(json)).toList();
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
