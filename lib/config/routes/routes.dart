import 'package:complaint_portal/common_widgets/error_screen.dart';
import 'package:complaint_portal/features/auth/screens/change_password_screen.dart';
import 'package:complaint_portal/features/auth/screens/forgot_password_screen.dart';
import 'package:complaint_portal/features/auth/screens/login_screen.dart';
import 'package:complaint_portal/features/location/screens/location_list_screen.dart';
import 'package:complaint_portal/features/notice/models/notice_board_model.dart';
import 'package:complaint_portal/features/sector_admin_home/models/sector_complaint_model.dart';
import 'package:complaint_portal/features/sector_admin_home/screens/create_technician_screen.dart';
import 'package:complaint_portal/features/sector_admin_home/screens/sector_admin_home.dart';
import 'package:complaint_portal/features/auth/screens/splash_screen.dart';
import 'package:complaint_portal/features/sector_admin_home/screens/sector_all_complaints_screen.dart';
import 'package:complaint_portal/features/sector_admin_home/screens/sector_complaint_details_screen.dart';
import 'package:complaint_portal/features/sector_admin_home/screens/sector_selection_screen.dart';
import 'package:complaint_portal/features/sector_admin_home/screens/technician_list_screen.dart';
import 'package:complaint_portal/features/super_admin_home/models/admin_complaint_model.dart';
import 'package:complaint_portal/features/super_admin_home/screens/active_sectors_screen.dart';
import 'package:complaint_portal/features/super_admin_home/screens/admin_complaint_details_screen.dart';
import 'package:complaint_portal/features/notice/screens/create_notice_screen.dart';
import 'package:complaint_portal/features/super_admin_home/screens/create_sector_admin_screen.dart';
import 'package:complaint_portal/features/notice/screens/notice_board_page.dart';
import 'package:complaint_portal/features/notice/screens/notice_detail_page.dart';
import 'package:complaint_portal/features/super_admin_home/screens/sector_admin_list_screen.dart';
import 'package:complaint_portal/features/super_admin_home/screens/super_admin_home.dart';
import 'package:complaint_portal/features/super_admin_home/screens/technician_selection_screen.dart';
import 'package:complaint_portal/features/notice/screens/update_notice_screen.dart';
import 'package:complaint_portal/features/super_admin_home/screens/view_all_complaints_screen.dart';
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
      case '/technician-list-screen':
        return _animatedRoute(const TechnicianListScreen(), name: '/technician-list-screen');
      case '/create-sector-admin-screen':
        return _animatedRoute(const CreateSectorAdminScreen(), name: '/create-sector-admin-screen');
      case '/complaint-details-screen':
        if (args != null && args is AdminComplaint) {
          return _animatedRoute(AdminComplaintDetailsScreen(data: args), name: '/complaint-details-screen');
        } else {
          return _animatedRoute(AdminComplaintDetailsScreen(complaintId: args as String, data: null,), name: '/complaint-details-screen');
        }
      case '/sector-complaint-details-screen':
        if (args != null && args is SectorComplaint) {
          return _animatedRoute(SectorComplaintDetailsScreen(data: args), name: '/sector-complaint-details-screen');
        } else {
          return _animatedRoute(SectorComplaintDetailsScreen(complaintId: args as String, data: null,), name: '/sector-complaint-details-screen');
        }
      case '/view-all-complaint-screen':
        if(args is String){
          return _animatedRoute(ViewAllComplaintScreen(status: args), name: '/view-all-complaint-screen');
        }else{
          return _animatedRoute(const ViewAllComplaintScreen(), name: '/view-all-complaint-screen');
        }
      case '/sector-all-complaint-screen':
        if(args is String){
          return _animatedRoute(SectorAllComplaintScreen(status: args), name: '/sector-all-complaint-screen');
        }else{
          return _animatedRoute(const SectorAllComplaintScreen(), name: '/sector-all-complaint-screen');
        }
      case '/create-worker-screen':
        return _animatedRoute(const CreateTechnicianScreen(), name: '/create-worker-screen');
      case '/tech-selection-screen':
        return _animatedRoute(TechnicianSelectionScreen(complaint: args as AdminComplaint), name: '/tech-selection-screen');
      case '/sector-selection-screen':
        return _animatedRoute(SectorSelectionScreen(complaint: args as SectorComplaint), name: '/sector-selection-screen');
      case '/notice-board-screen':
        return _animatedRoute(NoticeBoardPage(), name: '/notice-board-screen');
      case '/notice-detail-screen':
        return _animatedRoute(NoticeDetailPage(data: args as Notice,), name: '/notice-detail-screen');
      case '/create-notice-screen':
        return _animatedRoute(CreateNoticeScreen(), name: '/create-notice-screen');
      case '/update-notice-screen':
        return _animatedRoute(UpdateNoticeScreen(data: args as Notice), name: '/update-notice-screen');
      case '/location-list-screen':
        return _animatedRoute(const LocationListScreen(), name: '/location-list-screen');
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