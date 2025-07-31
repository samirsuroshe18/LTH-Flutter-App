import 'dart:io';

import 'package:complaint_portal/constants/server_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfService {
  static Future<bool> downloadLocationPDF(
    String id,
    String locationName,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final response = await http.get(
        Uri.parse(
          '${ServerConstant.baseUrl}/api/v1/location/single-location-pdf/$id',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        return await _savePDFToDownloads(
          response.bodyBytes,
          'location_${locationName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}_qr.pdf',
        );
      }
      return false;
    } catch (e) {
      debugPrint('Error downloading PDF: $e');
      return false;
    }
  }

  static Future<bool> downloadAllLocationsPDF() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final response = await http.get(
        Uri.parse('${ServerConstant.baseUrl}/api/v1/location/all-location-pdf'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final fileName =
            'all_locations_qr_${DateTime.now().toIso8601String().split('T')[0]}.pdf';
        return await _savePDFToDownloads(response.bodyBytes, fileName);
      }
      return false;
    } catch (e) {
      debugPrint('Error downloading all locations PDF: $e');
      return false;
    }
  }

  static Future<bool> _savePDFToDownloads(
    List<int> bytes,
    String fileName,
  ) async {
    try {
      // Request storage permission
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) {
            return false;
          }
        }
      }

      // Get downloads directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(bytes);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error saving PDF: $e');
      return false;
    }
  }
}
