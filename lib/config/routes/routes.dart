import 'package:complaint_portal/common_widgets/error_screen.dart';
import 'package:complaint_portal/features/auth/screens/change_password_screen.dart';
import 'package:complaint_portal/features/auth/screens/forgot_password_screen.dart';
import 'package:complaint_portal/features/auth/screens/login_screen.dart';
import 'package:complaint_portal/features/sector_admin_home/screens/sector_admin_home.dart';
import 'package:complaint_portal/features/auth/screens/splash_screen.dart';
import 'package:complaint_portal/features/super_admin_home/screens/active_sectors_screen.dart';
import 'package:complaint_portal/features/super_admin_home/screens/create_sector_admin_screen.dart';
import 'package:complaint_portal/features/super_admin_home/screens/sector_admin_list_screen.dart';
import 'package:complaint_portal/features/super_admin_home/screens/super_admin_home.dart';
import 'package:complaint_portal/features/technician_home/models/technician_complaint_model.dart';
import 'package:complaint_portal/features/technician_home/screens/submit_resolution_screen.dart';
import 'package:complaint_portal/features/technician_home/screens/technician_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case '/':
        return _animatedRoute(const SplashScreen(), name: '/');
      case '/login':
        return _animatedRoute(const LoginScreen(), name: '/login');
      case '/change-password':
        return _animatedRoute(const ChangePasswordScreen(), name: '/change-password');
      case '/forgot-password':
        return _animatedRoute(const ForgotPasswordScreen(), name: '/forgot-password');
      case '/super-admin-home':
        return _animatedRoute(const SuperAdminHome(), name: '/super-admin-home');
      case '/sector-admin-home':
        return _animatedRoute(const SectorAdminHome(), name: '/sector-admin-home');
      case '/technician-home':
        return _animatedRoute(const TechnicianHome(), name: '/technician-home');
      case '/error':
        if (args != null && args is Map<String, dynamic>) {
          return _animatedRoute(ErrorScreen(data: args), name: '/error');
        } else {
          return _animatedRoute(const ErrorScreen(data: {}), name: '/error');
        }
      case '/submit-resolution':
        return _animatedRoute(SubmitResolutionScreen(data: args as AssignComplaint), name: '/submit-resolution');
      case '/active-sectors-screen':
        return _animatedRoute(const ActiveSectorsScreen(), name: '/active-sectors-screen');
      case '/sector-admin-list-screen':
        return _animatedRoute(const SectorAdminListScreen(), name: '/sector-admin-list-screen');
      case '/create-sector-admin-screen':
        return _animatedRoute(const CreateSectorAdminScreen(), name: '/create-sector-admin-screen');
      case '/complaint-details-screen':
        return _animatedRoute(const CreateSectorAdminScreen(), name: '/complaint-details-screen');
      default:
        return _animatedRoute(const SplashScreen(), name: '/');
    }
  }

  static Route<dynamic> _animatedRoute(Widget page, {String? name}) {
    return PageRouteBuilder(
      settings: RouteSettings(name: name),
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.black.withValues(alpha: 0.2), // Apply opacity to the color
          statusBarIconBrightness: Brightness.light, // Adjust for visibility
        ));
        return page;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

}