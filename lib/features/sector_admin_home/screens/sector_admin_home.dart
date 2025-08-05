import 'dart:convert';

import 'package:complaint_portal/common_widgets/build_error_state.dart';
import 'package:complaint_portal/common_widgets/custom_loader.dart';
import 'package:complaint_portal/common_widgets/custom_snackbar.dart';
import 'package:complaint_portal/features/auth/bloc/auth_bloc.dart';
import 'package:complaint_portal/features/auth/models/user_model.dart';
import 'package:complaint_portal/features/notice/models/notice_board_model.dart';
import 'package:complaint_portal/features/sector_admin_home/bloc/sector_admin_home_bloc.dart';
import 'package:complaint_portal/features/sector_admin_home/models/sector_dashboard_overview.dart';
import 'package:complaint_portal/features/sector_admin_home/widgets/build_action_button.dart';
import 'package:complaint_portal/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SectorAdminHome extends StatefulWidget {
  const SectorAdminHome({super.key});

  @override
  State<SectorAdminHome> createState() => _SectorAdminHomeState();
}

class _SectorAdminHomeState extends State<SectorAdminHome> {
  NotificationAppLaunchDetails? notificationAppLaunchDetails;
  SectorDashboardOverview? data;
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;
  String? errorMessage;
  String selectedSector = 'All Sectors';
  String selectedTimeRange = 'Last 30 Days';
  BuildContext? _dialogContext;
  UserModel? user;

  void getInitialAction() async {
    notificationAppLaunchDetails = NotificationController.notificationAppLaunchDetails;
    Map<String, dynamic>? payload;
    if(notificationAppLaunchDetails?.notificationResponse?.payload != null){
      payload = jsonDecode(notificationAppLaunchDetails!.notificationResponse!.payload!);
    }
    if (mounted ) {
      if (notificationAppLaunchDetails != null && payload?['action'] == 'NOTIFY_NEW_COMPLAINT') {
        Navigator.pushNamed(context, '/sector-complaint-details-screen', arguments: payload?['complaintId']);
      } else if (notificationAppLaunchDetails != null && payload?['action'] == 'REVIEW_RESOLUTION') {
        Navigator.pushNamed(context, '/sector-complaint-details-screen', arguments: payload?['complaintId']);
      } else if (notificationAppLaunchDetails != null && payload?['action'] == 'NOTIFY_NOTICE') {
        Navigator.pushNamed(context, '/notice-detail-screen', arguments: Notice.fromJson(jsonDecode(payload?['noticeData'])));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    NotificationController.requestNotificationPermission();
    final authBloc = context.read<AuthBloc>();
    final UserModel? userState = authBloc.currentUser;
    if (userState != null) {
      user = userState;
    }
    context.read<SectorAdminHomeBloc>().add(GetSectorDashboardOverview());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInitialAction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLogoutLoading) {
            showLoadingDialog(context);
          }
          if (state is AuthLogoutSuccess) {
            Future.delayed(const Duration(seconds: 2), () {
              dismissLoadingDialog();
              CustomSnackBar.show(
                context: context,
                message: "Logout Successfully.",
                type: SnackBarType.success,
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (route) => false,
              );
            });
          }
          if (state is AuthLogoutFailure) {
            Future.delayed(const Duration(seconds: 2), () {
              dismissLoadingDialog();
              CustomSnackBar.show(
                context: context,
                message: state.message,
                type: SnackBarType.error,
              );
            });
          }
        },
        builder: (context, state) {
          return BlocConsumer<SectorAdminHomeBloc, SectorAdminHomeState>(
            listener: (context, state) {
              if (state is GetSectorDashboardOverviewLoading) {
                _isLoading = true;
                _isError = false;
              }
              if (state is GetSectorDashboardOverviewSuccess) {
                data = state.response;
                _isLoading = false;
                _isError = false;
              }
              if (state is GetSectorDashboardOverviewFailure) {
                data = null;
                _isLoading = false;
                _isError = true;
                statusCode = state.status;
                errorMessage = state.message;
                CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
              }
            },
            builder: (context, state) {
              if (data != null && _isLoading == false) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsSection(),
                        SizedBox(height: 24),
                        _buildQuickActionsSection(context),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              } else if (_isLoading) {
                return const CustomLoader();
              } else if (data == null && _isError == true && statusCode == 401) {
                return BuildErrorState(onRefresh: _onRefresh, errorMessage: errorMessage,);
              } else if (_isError == true && statusCode == 403) {
                return BuildErrorState(onRefresh: _onRefresh, errorMessage: errorMessage,);
              } else {
                return BuildErrorState(onRefresh: _onRefresh);
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    context.read<SectorAdminHomeBloc>().add(GetSectorDashboardOverview());
  }

  void _handleProfileMenuSelection(String value) {
    switch (value) {
      case 'profile':
        _showProfileDialog();
        break;
      case 'change_password':
        Navigator.pushNamed(context, '/change-password');
        break;
      case 'logout':
        _showLogoutDialog();
        break;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 12),
              Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog first
                context.read<AuthBloc>().add(
                  AuthLogout(),
                ); // Then trigger logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
        final isSmallScreen = screenSize.width < 400;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.transparent,
          child: Container(
            width: isSmallScreen ? screenSize.width * 0.9 : 400,
            constraints: BoxConstraints(
              maxWidth: screenSize.width * 0.9,
              maxHeight: screenSize.height * 0.8,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Section
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF2E3B4E),
                          Color(0xFF3A4A5C),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Profile Avatar
                        Container(
                          width: isSmallScreen ? 60 : 80,
                          height: isSmallScreen ? 60 : 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.3),
                                Colors.white.withValues(alpha: 0.1),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.person_outline,
                            size: isSmallScreen ? 30 : 40,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        Text(
                          'Profile Information',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 20 : 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Your account details',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content Section
                  Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildModernProfileRow(
                          icon: Icons.person_outline,
                          label: 'Full Name',
                          value: user?.userName ?? 'Not Available',
                          color: Colors.blue,
                          isSmallScreen: isSmallScreen,
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        _buildModernProfileRow(
                          icon: Icons.email_outlined,
                          label: 'Email Address',
                          value: user?.email ?? 'Not Available',
                          color: Colors.orange,
                          isSmallScreen: isSmallScreen,
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        _buildModernProfileRow(
                          icon: Icons.work_outline,
                          label: 'Role',
                          value: user?.role ?? 'Not Available',
                          color: Colors.green,
                          isSmallScreen: isSmallScreen,
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        _buildModernProfileRow(
                          icon: Icons.business_outlined,
                          label: 'Department',
                          value: user?.sectorType ?? 'Not Available',
                          color: Colors.purple,
                          isSmallScreen: isSmallScreen,
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 24),

                        // Action Buttons
                        isSmallScreen
                            ? Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: _buildActionButton(
                                icon: Icons.edit_outlined,
                                label: 'Edit Profile',
                                color: Color(0xFF2E3B4E),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Navigate to edit profile page
                                  CustomSnackBar.show(context: context, message: 'Edit Profile feature coming soon', type: SnackBarType.info);
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: _buildActionButton(
                                icon: Icons.close_outlined,
                                label: 'Close',
                                color: Colors.grey.shade600,
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ],
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              icon: Icons.edit_outlined,
                              label: 'Edit Profile',
                              color: Color(0xFF2E3B4E),
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Navigate to edit profile page
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Edit Profile feature coming soon'),
                                    backgroundColor: Color(0xFF2E3B4E),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                            ),
                            _buildActionButton(
                              icon: Icons.close_outlined,
                              label: 'Close',
                              color: Colors.grey.shade600,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernProfileRow({required IconData icon, required String label, required String value, required Color color, required bool isSmallScreen,}) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 35 : 40,
            height: isSmallScreen ? 35 : 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: isSmallScreen ? 18 : 20,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onPressed,}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 2,
        shadowColor: color.withValues(alpha: 0.3),
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        _dialogContext = dialogContext;
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Signing Out",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "We're securely logging you out of your account. This won't take long.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void dismissLoadingDialog() {
    if (_dialogContext != null) {
      Navigator.of(_dialogContext!, rootNavigator: true).pop();
      _dialogContext = null;
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.only(left: 10),
        // child: Image.asset('assets/images/lth_logo.png', color: Colors.white,),
        child: Image.asset('assets/images/app_log_transparent.png', color: Colors.white,),
      ),
      title: Text(
        'Niyamitra',
      ),
      backgroundColor: Colors.blue[700],
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: _isLoading
              ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : Icon(Icons.refresh, color: Colors.white),
          onPressed: _isLoading ? null : _onRefresh,
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.account_circle, color: Colors.white),
          onSelected: _handleProfileMenuSelection,
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.grey[700]),
                  SizedBox(width: 12),
                  Text('View Profile'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'change_password',
              child: Row(
                children: [
                  Icon(Icons.password, color: Colors.grey[700]),
                  SizedBox(width: 12),
                  Text('Change Password'),
                ],
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Logout', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard Overview',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          // childAspectRatio: 0.6,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildProfileStatCard(
              title: 'Pending Queries',
              value: data?.pendingQueries != null ? data!.pendingQueries.toString() : '0',
              icon: Icons.pending_actions,
              color: Colors.orange[600]!,
              trend: '-12 from yesterday',
              onTap: ()=> Navigator.pushNamed(context, '/sector-all-complaint-screen', arguments: 'Pending'),
            ),
            _buildProfileStatCard(
                title: 'In Progress Queries',
                value: data?.inProgressQueries != null ? data!.inProgressQueries.toString() : '0',
                icon: Icons.autorenew,
                color: Color(0xFFEF4444),
                trend: 'All operational',
                onTap: ()=> Navigator.pushNamed(context, '/sector-all-complaint-screen', arguments: 'In Progress'),
            ),
            _buildProfileStatCard(
              title: 'Reject Queries',
              value: data?.rejectedQueries != null ? data!.rejectedQueries.toString() : '0',
              icon: Icons.engineering,
              color: Colors.blue[600]!,
              trend: '+3 this month',
              onTap: ()=> Navigator.pushNamed(context, '/sector-all-complaint-screen', arguments: 'Rejected'),
            ),
            _buildProfileStatCard(
              title: 'Resolved Queries',
              value: data?.resolvedQueries != null ? data!.resolvedQueries.toString() : '0',
              icon: Icons.check_circle,
              color: Colors.green[600]!,
              trend: '+89 this week',
              onTap: ()=> Navigator.pushNamed(context, '/sector-all-complaint-screen', arguments: 'Resolved'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileStatCard({required String title, required String value, required IconData icon, required Color color, required String trend, VoidCallback? onTap,}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // radius here
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.dashboard,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Manage your dashboard efficiently',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Action buttons
          BuildActionButton(
            title: 'View All Queries',
            subtitle: 'Browse and manage all submitted queries',
            icon: Icons.list_alt_rounded,
            color: const Color(0xFF2563EB),
            onTap: () => Navigator.pushNamed(context, '/sector-all-complaint-screen'),
          ),

          const SizedBox(height: 16),

          BuildActionButton(
            title: 'Notice Board',
            subtitle: 'View announcements and important updates',
            icon: Icons.campaign_rounded,
            color: const Color(0xFF7C3AED),
            showBadge: true, // Example: showing notification badge
            onTap: () => Navigator.pushNamed(context, '/notice-board-screen'),
          ),

          const SizedBox(height: 16),

          BuildActionButton(
            title: 'Technical Staff Management',
            subtitle: 'Oversee technical team and assignments',
            icon: Icons.engineering_rounded,
            color: const Color(0xFFDC2626),
            onTap: () => Navigator.pushNamed(context, '/technician-list-screen'),
          ),

          const SizedBox(height: 16),

          BuildActionButton(
            title: 'Location Management',
            subtitle: 'Configure service areas and zones',
            icon: Icons.location_on_rounded,
            color: const Color(0xFFEA580C),
            onTap: () => Navigator.pushNamed(context, '/location-list-screen'),
          ),
        ],
      ),
    );
  }
}
