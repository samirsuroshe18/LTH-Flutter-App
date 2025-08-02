import 'package:complaint_portal/constants/server_constant.dart';
import 'package:complaint_portal/features/auth/bloc/auth_bloc.dart';
import 'package:complaint_portal/features/location/bloc/location_bloc.dart';
import 'package:complaint_portal/features/notice/bloc/notice_bloc.dart';
import 'package:complaint_portal/features/sector_admin_home/bloc/sector_admin_home_bloc.dart';
import 'package:complaint_portal/features/super_admin_home/bloc/super_admin_home_bloc.dart';
import 'package:complaint_portal/features/technician_home/bloc/technician_home_bloc.dart';
import 'package:complaint_portal/init_dependencies.dart';
import 'package:complaint_portal/utils/auth_http_client.dart';
import 'package:complaint_portal/utils/notification_service.dart';
import 'package:complaint_portal/utils/route_observer_with_stack.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes/routes.dart';
import 'firebase_options.dart';

// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserverWithStack routeObserver = RouteObserverWithStack();

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationController.initializeLocalNotifications();

  try {
    final int? id = message.data['notificationId'];
    if (message.data['action'] == 'CANCEL' && id != null) {
      NotificationController.cancelLocalNotification(id);
    } else {
      NotificationController.showLocalNotification(message: message);
    }
  } catch (e) {
    debugPrint('Error handling notification: $e');
  }
}

void main() async {

  ///ensureInitialized() is used in the main() to ensure that the Flutter framework is fully initialized before running any code that relies on it.
  WidgetsFlutterBinding.ensureInitialized();

  ///It is used to initialize Firebase in a Flutter app so that we can communicate with firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// FCM background handler
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  ///Initializing notification
  await NotificationController.initializeLocalNotifications();

  ///Dependency Injection.
  await initDependencies();

  /// AuthHttpClient Initialization
  AuthHttpClient.initialize(
    serverBaseUrl: ServerConstant.baseUrl,
    refreshEndpoint: ServerConstant.refreshTokenEndpoint,
    navKey: navigatorKey,
  );

  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => serviceLocator<AuthBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<TechnicianHomeBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<SuperAdminHomeBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<SectorAdminHomeBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<LocationBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<NoticeBloc>(),
            ),
          ],
          child: const MyApp()
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificationController.isInForeground = true;
    // FCM token refresh listener
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      if (mounted) {
        context.read<AuthBloc>().add(AuthUpdateFCM(FCMToken: newToken));
      }
    });
    _updateFcm();
  }

  Future<void> _updateFcm() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (mounted && fcmToken != null) {
      context.read<AuthBloc>().add(AuthUpdateFCM(FCMToken: fcmToken));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      NotificationController.isInForeground = true;
    }
    if(state == AppLifecycleState.paused){
      NotificationController.isInForeground = true;
    }
    if(state == AppLifecycleState.detached){
      NotificationController.isInForeground = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Complaint Portal',
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      initialRoute: '/',
    );
  }
}
