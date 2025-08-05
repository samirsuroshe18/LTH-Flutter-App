import 'dart:convert';
import 'package:complaint_portal/constants/server_constant.dart';
import 'package:complaint_portal/utils/api_error.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthHttpClient {
  static AuthHttpClient? _instance;
  static AuthHttpClient get instance => _instance ??= AuthHttpClient._();

  AuthHttpClient._();

  // Navigation key for logout navigation
  static GlobalKey<NavigatorState>? navigatorKey;

  // Token refresh endpoint
  static String refreshTokenEndpoint = ServerConstant.refreshTokenEndpoint;
  static String baseUrl = ServerConstant.baseUrl;

  // Flag to prevent multiple refresh attempts
  bool _isRefreshing = false;

  /// Initialize the client with necessary configurations
  static void initialize({
    required String serverBaseUrl,
    required String refreshEndpoint,
    GlobalKey<NavigatorState>? navKey,
  }) {
    baseUrl = serverBaseUrl;
    refreshTokenEndpoint = refreshEndpoint;
    navigatorKey = navKey;
  }

  /// GET request with auto token refresh
  Future<http.Response> get(
    String url,
    {
      Map<String, String>? headers,
      bool requiresAuth = true,
    }
  ) async {
    return _makeRequest(

      /// Api call Function param
      (mergedHeaders) {
        final finalHeaders = {
          ...mergedHeaders,
          if (headers != null) ...headers,
        };
        return http.get(Uri.parse(url), headers: finalHeaders);
      },

      /// is Requires Auth param
      requiresAuth: requiresAuth,
    );
  }

  /// POST request with auto token refresh
  Future<http.Response> post(
    String url,
    {
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      bool requiresAuth = true,
    }
  ) async {
    return _makeRequest(

      /// Api call Function param
      (mergedHeaders) {
        final finalHeaders = {
          ...mergedHeaders,
          if (headers != null) ...headers,
        };
        final uri = Uri.parse(url);
        return safePost(uri, finalHeaders, body, encoding);
      },

      /// is Requires Auth param
      requiresAuth: requiresAuth,
    );
  }

  /// PUT request with auto token refresh
  Future<http.Response> put(
    String url,
    {
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      bool requiresAuth = true,
    }
  ) async {
    return _makeRequest(

      /// Api call Function param
      (mergedHeaders) {
        final finalHeaders = {
          ...mergedHeaders,
          if (headers != null) ...headers,
        };
        final uri = Uri.parse(url);
        return safePut(uri, finalHeaders, body, encoding);
      },

      /// is Requires Auth param
      requiresAuth: requiresAuth,
    );
  }

  /// DELETE request with auto token refresh
  Future<http.Response> delete(
    String url,
    {
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      bool requiresAuth = true,
    }
  ) async {
    return _makeRequest(

      /// Api call Function param
      (mergedHeaders) {
        final finalHeaders = {
          ...mergedHeaders,
          if (headers != null) ...headers,
        };
        final uri = Uri.parse(url);
        return safeDelete(uri, finalHeaders, body, encoding);
      },

      /// is Requires Auth param
      requiresAuth: requiresAuth,
    );
  }

  /// Multipart request with auto token refresh
  Future<http.Response> multipartRequest(
    String method,
    String url,
    {
      Map<String, String>? fields,
      List<http.MultipartFile>? files,
      Map<String, String>? headers,
      bool requiresAuth = true,
    }
  ) async {
    return _makeMultipartRequest(
      method,
      url,
      fields: fields,
      files: files,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  /// Core method that handles the request with token refresh logic
  Future<http.Response> _makeRequest(
    Future<http.Response> Function(Map<String, String> headers) requestFunction,
    {
      bool requiresAuth = true,
      bool isRetry = false,
    }
  ) async {
    Map<String, String> headers = {};

    if (requiresAuth) {
      headers = await _getAuthHeaders();
    }

    try {
      final response = await requestFunction(headers);
      final jsonBody = jsonDecode(response.body);

      // Check if token expired (401) and this isn't already a retry
      if (response.statusCode == 401 && jsonBody['message'] == "Access token expired" && requiresAuth && !isRetry) {
        final refreshSuccess = await _refreshToken();

        if (refreshSuccess) {
          // Retry the request with new token
          return _makeRequest(requestFunction, requiresAuth: true, isRetry: true);
        } else {
          // Refresh failed, logout user
          await _handleLogout();
          throw ApiError(statusCode: response.statusCode, message: jsonBody['message']);
        }
      }

      return response;
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  /// Handle multipart requests with token refresh
  Future<http.Response> _makeMultipartRequest(
    String method,
    String url,
    {
      Map<String, String>? fields,
      List<http.MultipartFile>? files,
      Map<String, String>? headers,
      bool requiresAuth = true,
      bool isRetry = false,
    }
  ) async {
    try {
      final request = http.MultipartRequest(method, Uri.parse(url));

      // Add fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Add files
      if (files != null) {
        request.files.addAll(files);
      }

      // Add headers
      if (headers != null) {
        request.headers.addAll(headers);
      }

      // Add auth header if required
      if (requiresAuth) {
        final authHeaders = await _getAuthHeaders();
        request.headers.addAll(authHeaders);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final jsonBody = jsonDecode(response.body);

      // Check if token expired (401) and this isn't already a retry
      if (response.statusCode == 401 && jsonBody['message'] == "Access token expired" && requiresAuth && !isRetry) {
        final refreshSuccess = await _refreshToken();

        if (refreshSuccess) {
          // Retry the request with new token
          return _makeMultipartRequest(
            method,
            url,
            fields: fields,
            files: files,
            headers: headers,
            requiresAuth: true,
            isRetry: true,
          );
        } else {
          // Refresh failed, logout user
          await _handleLogout();
          throw ApiError(statusCode: response.statusCode, message: jsonBody['message']);
        }
      }

      return response;
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  /// Get authorization headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    return {
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };
  }

  /// Refresh the access token
  Future<bool> _refreshToken() async {
    if (_isRefreshing) {
      // Wait for ongoing refresh to complete
      await Future.delayed(const Duration(milliseconds: 100));
      return _isRefreshing == false;
    }

    _isRefreshing = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');

      if (refreshToken == null) {
        return false;
      }

      final response = await http.get(
        Uri.parse('$baseUrl$refreshTokenEndpoint'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $refreshToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Update tokens in SharedPreferences
        final newAccessToken = responseData['data']['accessToken'].toString();

        await prefs.setString('accessToken', newAccessToken);

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Token refresh failed: $e');
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Handle user logout when refresh fails
  Future<void> _handleLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');

      final response = await http.get(
        Uri.parse('$baseUrl${ServerConstant.logoutEndpoint}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $refreshToken',
        },
      );

      if(response.statusCode!=200){
        debugPrint('Logout failed: ${response.body}');
      }

      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      await prefs.clear();

      // Navigate to login screen
      if (navigatorKey?.currentContext != null) {
        final context = navigatorKey!.currentContext!;

        // Show session expired message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please log in again.'),
            backgroundColor: Colors.red,
          ),
        );

        // Navigate to login screen (replace with your login route)
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', // Replace with your login route
              (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Logout handling failed: $e');
    }
  }

  Future<http.Response> safePut(Uri uri, Map<String, String> headers, Object? body, Encoding? encoding,) {
    if (body == null && encoding == null) {
      return http.put(uri, headers: headers);
    } else if (body != null && encoding == null) {
      return http.put(uri, headers: headers, body: body);
    } else if (body != null && encoding != null) {
      return http.put(uri, headers: headers, body: body, encoding: encoding);
    } else {
      return http.put(uri, headers: headers);
    }
  }

  Future<http.Response> safePost(Uri uri, Map<String, String> headers, Object? body, Encoding? encoding,) {
    if (body == null && encoding == null) {
      return http.post(uri, headers: headers);
    } else if (body != null && encoding == null) {
      return http.post(uri, headers: headers, body: body);
    } else if (body != null && encoding != null) {
      return http.post(uri, headers: headers, body: body, encoding: encoding);
    } else {
      return http.post(uri, headers: headers);
    }
  }

  Future<http.Response> safeDelete(Uri uri, Map<String, String> headers, Object? body, Encoding? encoding,) {
    if (body == null && encoding == null) {
      return http.delete(uri, headers: headers);
    } else if (body != null && encoding == null) {
      return http.delete(uri, headers: headers, body: body);
    } else if (body != null && encoding != null) {
      return http.delete(uri, headers: headers, body: body, encoding: encoding);
    } else {
      return http.delete(uri, headers: headers);
    }
  }
}