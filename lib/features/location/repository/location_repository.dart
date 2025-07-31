import 'dart:convert';

import 'package:complaint_portal/constants/server_constant.dart';
import 'package:complaint_portal/features/location/models/location_model.dart';
import 'package:complaint_portal/utils/auth_http_client.dart';
import 'package:complaint_portal/utils/api_error.dart';
class LocationRepository {

  Future<Location> addNewLocation({required String name, required List<String> sectors}) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'sectors': sectors,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/location/add-new-location';

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
        return Location.fromJson(jsonBody['data']);
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

  Future<LocationModel> getAllLocations({required Map<String, dynamic> queryParams}) async {
    try {
      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/location/get-locations';
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
        return LocationModel.fromJson(jsonBody['data']);
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

  Future<Location> updateLocation({required String id, required String name, required List<String> sectors}) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'sectors': sectors,
      };

      final apiUrl = '${ServerConstant.baseUrl}/api/v1/location/update-location/$id';

      final response = await AuthHttpClient.instance.put(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Location.fromJson(jsonBody['data']);
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

  Future<Location> deleteLocation({required String id}) async {
    try {
      final apiUrl = '${ServerConstant.baseUrl}/api/v1/location/delete-location/$id';

      final response = await AuthHttpClient.instance.delete(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          requiresAuth: true
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Location.fromJson(jsonBody['data']);
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
