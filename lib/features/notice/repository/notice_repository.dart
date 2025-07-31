import 'dart:convert';
import 'dart:io';

import 'package:complaint_portal/constants/server_constant.dart';
import 'package:complaint_portal/features/notice/models/notice_board_model.dart';
import 'package:complaint_portal/utils/auth_http_client.dart';
import 'package:complaint_portal/utils/api_error.dart';
import 'package:http/http.dart' as http;

class NoticeRepository {

  Future<Notice> createNotice({required String title, required String description, File? file}) async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/notice/create-notice';

      final fields = {
        'title': title,
        'description': description,
      };

      // Only create multipart file if file is not null
      List<http.MultipartFile> files = [];
      if (file != null) {
        files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      // Use AuthHttpClient for multipart request
      final response = await AuthHttpClient.instance.multipartRequest(
        'POST',
        apiUrl,
        fields: fields,
        files: files,
      );

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
      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/notice/get-notices';
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
    try {
      final apiUrl = '${ServerConstant.baseUrl}/api/v1/notice/update-notice/$id';

      final fields = {
        'title': title,
        'description': description,
      };
      if (image != null) fields['image'] = image;

      // Only create multipart file if file is not null
      List<http.MultipartFile> files = [];
      if (file != null) {
        files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      // Use AuthHttpClient for multipart request
      final response = await AuthHttpClient.instance.multipartRequest(
        'PUT',
        apiUrl,
        fields: fields,
        files: files,
      );

      // Handle the response
      final jsonResponse = jsonDecode(response.body);

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
      final apiUrl = '${ServerConstant.baseUrl}/api/v1/notice/delete-notice/$id';

      final response = await AuthHttpClient.instance.delete(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          requiresAuth: true
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
