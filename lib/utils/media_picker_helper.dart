import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:complaint_portal/common_widgets/custom_snackbar.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class MediaPickerHelper {
  static const supportedImageTypes = ['.jpg', '.jpeg', '.png'];

  static Future<File?> pickPdfFile({required BuildContext context, int maxSizeInMB = 1,}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
        withData: true,
        onFileLoading: (FilePickerStatus status) => dev.log('FilePicker status: $status'),
      );

      if (result != null) {
        final fileBytes = result.files.single.bytes;
        final fileSize = result.files.single.size;
        final fileName = result.files.single.name;
        final filePath = result.files.single.path;

        if (fileSize > maxSizeInMB * 1024 * 1024) {
          _showErrorSnackBar(context, 'PDF size should not exceed $maxSizeInMB MB');
          return null;
        }

        if (filePath == null && fileBytes != null) {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/$fileName');
          await file.writeAsBytes(fileBytes);
          return file;
        } else if (filePath != null) {
          return File(filePath);
        }
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Error picking PDF: $e');
    }

    return null;
  }

  static Future<File?> pickImageFile({
    required BuildContext context,
    required ImageSource source,
    int maxSizeInMB = 1,
  }) async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        File imageFile = File(image.path);
        final int fileSize = await imageFile.length();
        final String ext = path.extension(image.path).toLowerCase();

        // Check file type
        if (!supportedImageTypes.contains(ext)) {
          _showErrorSnackBar(context, 'Only JPG, JPEG or PNG images are allowed');
          return null;
        }

        // If file size is larger than the maximum allowed
        if (fileSize > maxSizeInMB * 1024 * 1024) {
          // Different behavior based on source
          if (source == ImageSource.camera) {
            // For camera photos, compress automatically
            // Calculate target size (aim for 80% of max to ensure we're under the limit)
            int targetSize = (maxSizeInMB * 1024 * 1024 * 0.8).round();

            // Create a temporary file to store the compressed image
            String dir = path.dirname(image.path);
            String newPath = path.join(dir, 'compressed_${path.basename(image.path)}');

            // Start with a reasonable quality (higher for smaller files)
            int quality = 85;

            // For larger files, start with a lower quality to speed up compression
            if (fileSize > 5 * 1024 * 1024) { // If larger than 5MB
              quality = 70;
            }

            // Show a loading indicator or message
            CustomSnackBar.show(context: context, message: 'Image is large, compressing...', type: SnackBarType.info);

            // Compress the image
            File? compressedFile = await _compressImage(
                imageFile,
                newPath,
                quality: quality,
                targetSize: targetSize
            );

            if (compressedFile != null) {
              return compressedFile;
            } else {
              _showErrorSnackBar(context, 'Could not compress image to required size');
              return null;
            }
          } else {
            // For gallery photos, just show error message
            _showErrorSnackBar(context, 'Image size should not exceed $maxSizeInMB MB. Please select a smaller image.');
            return null;
          }
        }

        return imageFile;
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Error picking image: $e');
    }

    return null;
  }

// Helper method to compress an image with progressive quality reduction
  static Future<File?> _compressImage(
      File file,
      String targetPath,
      {required int quality,
        required int targetSize,
        int minQuality = 30,
        int maxAttempts = 3}
      ) async {
    int currentQuality = quality;
    int attempts = 0;
    File? result;

    while (attempts < maxAttempts) {
      attempts++;

      try {
        // Get the original image extension
        String ext = path.extension(file.path).toLowerCase();

        // Choose the correct compress format
        CompressFormat format;
        if (ext == '.png') {
          format = CompressFormat.png;
        } else {
          format = CompressFormat.jpeg;
        }

        // Compress the image
        XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetPath,
          quality: currentQuality,
          format: format,
        );

        if (compressedFile != null) {
          File resultFile = File(compressedFile.path);
          int resultSize = await resultFile.length();

          // If we achieved target size, return the file
          if (resultSize <= targetSize) {
            return resultFile;
          }

          // If file is still too large, reduce quality and try again
          currentQuality = max(currentQuality - 15, minQuality);
          result = resultFile; // Save this result in case we need to use it
        } else {
          // Compression failed, break the loop
          break;
        }
      } catch (e) {
        debugPrint('Error compressing image: $e');
        break;
      }
    }

    // Return the last compressed result, even if it's over the target size
    // This is better than returning null if we made some progress
    return result;
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    CustomSnackBar.show(context: context, message: message, type: SnackBarType.error);
  }
}
