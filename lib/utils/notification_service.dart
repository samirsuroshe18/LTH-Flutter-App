import 'dart:async';
import 'dart:convert';

import 'package:complaint_portal/utils/route_observer_with_stack.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:complaint_portal/constants/notification_constant.dart';
import 'package:complaint_portal/main.dart';
import 'package:http/http.dart' as http;

class NotificationController {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static NotificationAppLaunchDetails? notificationAppLaunchDetails;
  static bool isInForeground = false;

  static Future<void> initializeLocalNotifications() async {
    const androidInit = AndroidInitializationSettings("@mipmap/ic_launcher");

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [/* ... */],
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _onResponse,
      onDidReceiveBackgroundNotificationResponse: _onResponseBackground,
    );

    await _createChannels();

    notificationAppLaunchDetails = await _plugin.getNotificationAppLaunchDetails();

    // Get any messages which caused the application to open from a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // Handle initial message if exists
    if (initialMessage != null) {
      _handleRemoteMessage(initialMessage);
    }

    // Background: Handle notification tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleRemoteMessage(message);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        final int? id = message.data['notificationId'];
        if (message.data['action'] == 'CANCEL' && id != null) {
          cancelLocalNotification(id);
        } else {
          NotificationController.showLocalNotification(message: message);
        }
      } catch (e) {
        debugPrint('Error handling notification: $e');
      }
    });
  }

  static Future<void> _createChannels() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (android != null) {
      await android.createNotificationChannel(const AndroidNotificationChannel(
          NotificationConstant.channelId,
          NotificationConstant.channelName,
          description: NotificationConstant.channelDesc,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('notification_sound'),
          importance: Importance.max,
          enableLights: true,
          enableVibration: true
      ));
    }
  }

  static Future<void> showLocalNotification({required RemoteMessage message}) async {
    try {
      final data = message.data;
      final action = data['action'] ?? '';
      BigPictureStyleInformation? style;

      final notificationId = data['notificationId'] ?? DateTime.now().millisecondsSinceEpoch.remainder(100000);
      final title = getTitle(action, data);
      final body = getBody(action, data);
      final String? imageUrl = data['imageUrl'];

      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          final resp = await http.get(Uri.parse(imageUrl));
          final bytes = resp.bodyBytes;
          style = BigPictureStyleInformation(
            ByteArrayAndroidBitmap(bytes),
            largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            contentTitle: title,
            summaryText: body,
            htmlFormatContentTitle: true,
            htmlFormatSummaryText: true,
          );
        } catch (e) {
          debugPrint('Error loading notification image: $e');
        }
      }

      final androidDetails = AndroidNotificationDetails(
          NotificationConstant.channelId,
          NotificationConstant.channelName,
          channelDescription: NotificationConstant.channelDesc,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          visibility: NotificationVisibility.public,
          importance: Importance.max,
          priority: Priority.max,
          category: AndroidNotificationCategory.alarm,
          styleInformation: style,
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher')
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(
          categoryIdentifier: 'actionable',
          attachments: imageUrl != null ? [DarwinNotificationAttachment(imageUrl)] : null,
        ),
      );

      await _plugin.show(notificationId, title, body, details, payload: jsonEncode(data));
    } catch (e) {
      debugPrint('Error showing local notification: $e');
    }
  }

  static Future<void> cancelLocalNotification(int id) => _plugin.cancel(id);

  static Future<void> cancelAllLocalNotification() => _plugin.cancelAll();

  // Internal callbacks
  static void _onResponse(NotificationResponse response) {
    _handleNotificationResponse(response);
  }

  @pragma('vm:entry-point')
  static void _onResponseBackground(NotificationResponse response) {
    _handleNotificationResponse(response);
  }

  // Handle RemoteMessage (for app launch from terminated state)
  static void _handleRemoteMessage(RemoteMessage message) {
    try {
      if (message.data['action'] != null) {
        final payload = message.data;
        final action = message.data['action'] ?? '';
        _navigateBasedOnAction(action, payload);
      }
    } catch (e) {
      debugPrint('Error handling remote message: $e');
    }
  }

  // Handle NotificationResponse (for notification taps)
  static void _handleNotificationResponse(NotificationResponse response) {
    try {
      if (response.payload != null) {
        final data = jsonDecode(response.payload!);
        if (data['payload'] != null) {
          final payload = data;
          final action = data['action'] ?? '';
          _navigateBasedOnAction(action, payload);
        }
      }
    } catch (e) {
      debugPrint('Error handling notification response: $e');
    }
  }

  // Centralized navigation logic
  static void _navigateBasedOnAction(String action, Map<String, dynamic> payload) {
    final NavigatorState? currentState = navigatorKey.currentState;

    if (payload['action'] == 'NOTIFY_ADMIN_REPLIED' && isInForeground == true) {
      if(getCurrentRouteName() == '/complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/complaint-details-screen', arguments: {'id': payload['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/complaint-details-screen', arguments: {'id': payload['id']});
        });
      }
    } else if (payload['action'] == 'REVIEW_RESOLUTION' && isInForeground == true) {
      if(getCurrentRouteName() == '/complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/complaint-details-screen', arguments: {'id': payload['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/complaint-details-screen', arguments: {'id': payload['id']});
        });
      }
    } else if (payload['action'] == 'ASSIGN_COMPLAINT' && isInForeground == true) {
      if(getCurrentRouteName() == '/tech-complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/tech-complaint-details-screen', arguments: {'id': payload['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/tech-complaint-details-screen', arguments: {'id': payload['id']});
        });
      }
    } else if (payload['action'] == 'RESOLUTION_APPROVED' && isInForeground == true) {
      if(getCurrentRouteName() == '/tech-complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/tech-complaint-details-screen', arguments: {'id': payload['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/tech-complaint-details-screen', arguments: {'id': payload['id']});
        });
      }
    } else if (payload['action'] == 'RESOLUTION_REJECTED' && isInForeground == true) {
      if(getCurrentRouteName() == '/tech-complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/tech-complaint-details-screen', arguments: {'id': payload['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/tech-complaint-details-screen', arguments: {'id': payload['id']});
        });
      }
    }
  }

  static String getTitle(String action, Map<String, dynamic> payload) {
    switch (action) {
      case "ASSIGN_COMPLAINT":
      case "REVIEW_RESOLUTION":
      case "RESOLUTION_APPROVED":
      case "RESOLUTION_REJECTED":
        return payload['title'] ?? "Notification";
      default:
        return payload['title'] ?? "Notification";
    }
  }

  static String getBody(String action, Map<String, dynamic> payload) {
    switch (action) {
      case "ASSIGN_COMPLAINT":
      case "REVIEW_RESOLUTION":
      case "RESOLUTION_APPROVED":
      case "RESOLUTION_REJECTED":
        return payload['message'] ?? payload['body'] ?? "You have a new notification";
      default:
        return payload['body'] ?? "You have a new notification";
    }
  }

  static Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('user granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('user granted provisional permission');
    } else {
      debugPrint('user denied permission');
    }
  }
}


// if (!isInForeground) return;
//
// final NavigatorState? currentState = navigatorKey.currentState;
// if (currentState == null) return;
//
// String? targetRoute;
// Map<String, dynamic>? arguments;
//
// switch (action) {
// case 'NOTIFY_ADMIN_REPLIED':
// case 'REVIEW_RESOLUTION':
// targetRoute = '/complaint-details-screen';
// arguments = {'id': payload['id']};
// break;
//
// case 'ASSIGN_COMPLAINT':
// case 'RESOLUTION_APPROVED':
// case 'RESOLUTION_REJECTED':
// targetRoute = '/tech-complaint-details-screen';
// arguments = {'id': payload['id']};
// break;
// }
//
// if (targetRoute != null) {
// WidgetsBinding.instance.addPostFrameCallback((_) {
// final currentRoute = getCurrentRouteName();
// if (currentRoute == targetRoute) {
// currentState.pushReplacementNamed(targetRoute!, arguments: arguments);
// } else {
// currentState.pushNamed(targetRoute!, arguments: arguments);
// }
// });
// }