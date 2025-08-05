import 'dart:io';

import 'package:complaint_portal/constants/server_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:media_store_plus/media_store_plus.dart';

class PdfService {
  static Future<bool> downloadLocationPDF(String id, String locationName, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final response = await http.get(
        Uri.parse('${ServerConstant.baseUrl}/api/v1/location/single-location-pdf/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final fileName = 'location_${locationName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}_qr.pdf';
        return await _savePDFToDownloads(response.bodyBytes, fileName, context);
      }
      return false;
    } catch (e) {
      debugPrint('Error downloading PDF: $e');
      return false;
    }
  }

  static Future<bool> downloadAllLocationsPDF(BuildContext context) async {
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
        final fileName = 'all_locations_qr_${DateTime.now().toIso8601String().split('T')[0]}.pdf';
        return await _savePDFToDownloads(response.bodyBytes, fileName, context);
      }
      return false;
    } catch (e) {
      debugPrint('Error downloading all locations PDF: $e');
      return false;
    }
  }

  static Future<bool> _savePDFToDownloads(List<int> bytes, String fileName, BuildContext context) async {
    File? tempFile;
    try {
      await [
        Permission.storage,
      ].request();

      // 🔹 Write the PDF to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/$fileName';
      tempFile = File(tempPath);
      await tempFile.writeAsBytes(bytes);

      // 🔹 Verify file exists before proceeding
      if (!await tempFile.exists()) {
        debugPrint('Temporary file was not created successfully');
        return false;
      }

      debugPrint('Temporary file created at: $tempPath');
      debugPrint('File size: ${await tempFile.length()} bytes');

      // 🔹 Ensure MediaStore is initialized before using
      await MediaStore.ensureInitialized();

      // 🔹 Set the app folder BEFORE using MediaStore
      MediaStore.appFolder = "Niyamitra"; // Replace with your actual app name

      // 🔹 Save using MediaStore
      final mediaStore = MediaStore();
      final result = await mediaStore.saveFile(
        tempFilePath: tempPath,
        dirType: DirType.download,
        dirName: DirName.download,
      );

      if (result != null) {
        debugPrint('Saved PDF to: ${result.uri}');
        return true;
      } else {
        debugPrint('MediaStore returned null');
        return false;
      }
    } catch (e) {
      debugPrint('MediaStore error: $e');
      return false;
    } finally {
      // 🔹 Clean up temporary file in finally block
      if (tempFile != null && await tempFile.exists()) {
        try {
          await tempFile.delete();
          debugPrint('Temporary file cleaned up successfully');
        } catch (deleteError) {
          debugPrint('Failed to delete temporary file: $deleteError');
        }
      }
    }
  }
}