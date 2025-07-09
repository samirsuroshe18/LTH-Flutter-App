import 'package:complaint_portal/features/auth/bloc/auth_bloc.dart';
import 'package:complaint_portal/features/technician_home/bloc/technician_home_bloc.dart';
import 'package:complaint_portal/init_dependencies.dart';
import 'package:complaint_portal/utils/notification_service.dart';
import 'package:complaint_portal/utils/route_observer_with_stack.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes/routes.dart';
import 'firebase_options.dart';
import 'features/sector_admin_home/bloc/auth_bloc.dart' as sector_admin_auth;
import 'features/sector_admin_home/screens/sector_admin_home.dart';

// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserverWithStack routeObserver = RouteObserverWithStack();

void main() async {

  ///ensureInitialized() is used in the main() to ensure that the Flutter framework is fully initialized before running any code that relies on it.
  WidgetsFlutterBinding.ensureInitialized();

  ///It is used to initialize Firebase in a Flutter app so that we can communicate with firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final token = await FirebaseMessaging.instance.getToken();
  debugPrint('FCM Token : $token');

  ///Initializing notification
  await NotificationController.initializeLocalNotifications();

  ///Dependency Injection.
  await initDependencies();

  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => serviceLocator<AuthBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<TechnicianHomeBloc>(),
            ),
            BlocProvider<sector_admin_auth.AuthBloc>(
              create: (_) => serviceLocator<sector_admin_auth.AuthBloc>(),
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
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Complaint Portal',
      onGenerateRoute: (settings) {
        if (settings.name == '/sectorAdminHome') {
          return MaterialPageRoute(
            builder: (context) => BlocProvider<sector_admin_auth.AuthBloc>.value(
              value: serviceLocator<sector_admin_auth.AuthBloc>(),
              child: SectorAdminHome(),
            ),
          );
        }
        return AppRoutes.onGenerateRoutes(settings);
      },
      initialRoute: '/',
    );
  }
}
