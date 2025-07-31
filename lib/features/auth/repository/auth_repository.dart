import 'dart:convert';

import 'package:complaint_portal/constants/server_constant.dart';
import 'package:complaint_portal/utils/auth_http_client.dart';
import 'package:complaint_portal/utils/api_error.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:complaint_portal/features/auth/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {

  Future<UserModel> signInUser({required String email, required String password, required String role}) async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      final Map<String, dynamic> data = {
        'email': email,
        'password': password,
        'FCMToken': fcmToken,
        'role': role
      };

      const apiKey = '${ServerConstant.baseUrl}/api/v1/user/login';

      final response = await AuthHttpClient.instance.post(
        apiKey,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
        requiresAuth: false
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 401) {
        throw ApiError(
            statusCode: response.statusCode,
            message: jsonDecode(response.body)['message']);
      }

      if (response.statusCode == 200) {
        final accessToken = jsonBody['data']['accessToken'].toString();
        final refreshToken = jsonBody['data']['refreshToken'].toString();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("accessToken", accessToken);
        await prefs.setString("refreshToken", refreshToken);

        return UserModel.fromJson(jsonBody['data']['loggedInUser']);
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

  Future<Map<String, dynamic>> logoutUser() async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? refreshToken = prefs.getString('refreshToken');

      const apiKey = '${ServerConstant.baseUrl}/api/v1/user/logout';

      final response = await AuthHttpClient.instance.get(
          apiKey,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $refreshToken',
          },
          requiresAuth: false
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await prefs.remove("accessToken");
        await prefs.remove("refreshMode");
        return jsonBody;
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

  Future<UserModel> getUser() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/user/get-current-user';

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonBody['data']);
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

  Future<Map<String, dynamic>> updateFCM({required String fcmToken}) async {
    try {
      final Map<String, dynamic> data = {
        'FCMToken': fcmToken,
      };

      const apiKey = '${ServerConstant.baseUrl}/api/v1/user/update-fcm';

      final response = await AuthHttpClient.instance.post(
          apiKey,
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

  Future<Map<String, dynamic>> changePassword({required String oldPassword, required String newPassword}) async {
    try {
      final Map<String, dynamic> data = {
        'oldPassword': oldPassword,
        'newPassword': newPassword
      };

      const apiKey = '${ServerConstant.baseUrl}/api/v1/user/change-password';

      final response = await AuthHttpClient.instance.post(
          apiKey,
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

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      final Map<String, dynamic> data = {
        'email': email,
      };

      const apiKey = '${ServerConstant.baseUrl}/api/v1/user/forgot-password';

      final response = await AuthHttpClient.instance.post(
          apiKey,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
          requiresAuth: false
      );

      final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonBody;
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
