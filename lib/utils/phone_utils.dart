import 'package:complaint_portal/common_widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneUtils {
  static Future<void> makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri url = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      CustomSnackBar.show(context: context, message: 'Could not place the call', type: SnackBarType.error);
    }
  }

  static Future<void> sendSms(BuildContext context, String phoneNumber, String message) async {
    final Uri url = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message},
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      CustomSnackBar.show(context: context, message: 'Could not open SMS app. Please try again.', type: SnackBarType.error);
    }
  }

  static Future<void> sendEmail({
    required BuildContext context,
    required String email,
    String subject = 'Support Request',
    String body = 'Hello, I need help with...',
  }) async {
    if (email.trim().isEmpty) {
      CustomSnackBar.show(
        context: context,
        message: 'Email address is not available',
        type: SnackBarType.error,
      );
      return;
    }

    final Uri url = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject.isNotEmpty) 'subject': subject,
        if (body.isNotEmpty) 'body': body,
      },
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      CustomSnackBar.show(
        context: context,
        message: 'Could not open mail app',
        type: SnackBarType.error,
      );
    }
  }
}
