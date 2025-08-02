import 'dart:io';

import 'package:complaint_portal/constants/server_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    try {
      // Request MANAGE_EXTERNAL_STORAGE permission for Android
      if (Platform.isAndroid) {
        PermissionStatus status = await Permission.manageExternalStorage.status;

        if (!status.isGranted) {
          // Show custom dialog explaining why we need this permission
          bool? userConsent = await _showPermissionDialog(context);

          if (userConsent == true) {
            status = await Permission.manageExternalStorage.request();

            if (!status.isGranted) {
              return false;
            }
          } else {
            return false;
          }
        }
      }

      // Get the appropriate directory
      Directory? directory;
      if (Platform.isAndroid) {
        try {
          // Try to use Downloads directory
          directory = Directory('/storage/emulated/0/Download');

          // Check if directory exists and is writable
          if (!await directory.exists()) {
            directory = await getExternalStorageDirectory();
          } else {
            // Test write permission by creating a temporary file
            try {
              final testFile = File('${directory.path}/.test_write_permission');
              await testFile.writeAsString('test');
              await testFile.delete();
            } catch (e) {
              directory = await getExternalStorageDirectory();
            }
          }
        } catch (e) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(bytes);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error saving PDF: $e');
      return false;
    }
  }

  // Helper method to show permission dialog
  static Future<bool?> _showPermissionDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('File Access Permission'),
          content: const Text(
              'This app needs permission to manage files to save PDFs to your Downloads folder. '
                  'You will be redirected to Settings where you can grant "Allow management of all files" permission.'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Grant Permission'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}