import 'package:complaint_portal/common_widgets/build_error_state.dart';
import 'package:complaint_portal/common_widgets/custom_loader.dart';
import 'package:complaint_portal/common_widgets/custom_snackbar.dart';
import 'package:complaint_portal/features/auth/bloc/auth_bloc.dart';
import 'package:complaint_portal/features/super_admin_home/bloc/super_admin_home_bloc.dart';
import 'package:complaint_portal/features/super_admin_home/models/dashboard_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuperAdminHome extends StatefulWidget {
  const SuperAdminHome({super.key});

  @override
  State<SuperAdminHome> createState() => _SuperAdminHomeState();
}

class _SuperAdminHomeState extends State<SuperAdminHome> {
  DashboardOverview? data;
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;
  String selectedSector = 'All Sectors';
  String selectedTimeRange = 'Last 30 Days';
  BuildContext? _dialogContext;
  AuthGetUserSuccess? user;

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    if(state is AuthGetUserSuccess){
      user = state;
    }
    context.read<SuperAdminHomeBloc>().add(GetDashboardOverview());
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
          return BlocConsumer<SuperAdminHomeBloc, SuperAdminHomeState>(
            listener: (context, state) {
              if (state is GetDashboardOverviewLoading) {
                _isLoading = true;
                _isError = false;
              }
              if (state is GetDashboardOverviewSuccess) {
                data = state.response;
                _isLoading = false;
                _isError = false;
              }
              if (state is GetDashboardOverviewFailure) {
                data = null;
                _isLoading = false;
                _isError = true;
                statusCode = state.status;
                CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
              }
            },
            builder: (context, state) {
              if (data != null && _isLoading == false) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsSection(),
                      SizedBox(height: 24),
                      _buildQuickActionsSection(),
                      SizedBox(height: 24),
                      // _buildFiltersSection(),
                      // SizedBox(height: 24),
                      // _buildRecentActivitySection(),
                    ],
                  ),
                );
              } else if (_isLoading) {
                return const CustomLoader();
              } else if (data != null && _isError == true && statusCode == 401) {
                return BuildErrorState(onRefresh: _onRefresh);
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
    context.read<SuperAdminHomeBloc>().add(GetDashboardOverview());
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

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[800])),
          ),
        ],
      ),
    );
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF2E3B4E),
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileRow('Name', user?.response.userName ?? 'NA'),
              _buildProfileRow('Email', user?.response.email ?? 'NA'),
            ],
          ),
          actions: [
            // TextButton(
            //   onPressed: () => Navigator.of(context).pop(),
            //   child: Text('Close'),
            // ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to edit profile page
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('Edit Profile feature coming soon')),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E3B4E),
                foregroundColor: Colors.white,
              ),
              child: Text('Close'),
            ),
          ],
        );
      },
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
      leading: Icon(Icons.dashboard, color: Colors.white,),
      title: Text(
        'ComplaintDesk',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
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
            _buildStatCard(
              title: 'Total Sector Admins',
              value: data?.totalSectorAdmins != null ? data!.totalSectorAdmins.toString() : '0',
              icon: Icons.admin_panel_settings,
              color: Colors.blue[600]!,
              trend: '+3 this month',
              onTap: ()=> Navigator.pushNamed(context, '/sector-admin-list-screen'),
            ),
            _buildStatCard(
              title: 'Pending Queries',
              value: data?.pendingQueries != null ? data!.pendingQueries.toString() : '0',
              icon: Icons.pending_actions,
              color: Colors.orange[600]!,
              trend: '-12 from yesterday',
            ),
            _buildStatCard(
              title: 'Resolved Queries',
              value: data?.resolvedQueries != null ? data!.resolvedQueries.toString() : '0',
              icon: Icons.check_circle,
              color: Colors.green[600]!,
              trend: '+89 this week',
            ),
            // _buildStatCard(
            //   title: 'In Progress Queries',
            //   value: '68',
            //   icon: Icons.autorenew,
            //   color: Colors.amber[600]!,
            //   trend: 'Updating live',
            // ),
            _buildStatCard(
              title: 'Active Sectors',
              value: data?.totalActiveSectors != null ? data!.totalActiveSectors.toString() : '0',
              icon: Icons.domain,
              color: Colors.purple[600]!,
              trend: 'All operational',
              onTap: ()=> Navigator.pushNamed(context, '/active-sectors-screen'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
    VoidCallback? onTap,
  }) {
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
                child: Icon(icon, color: color, size: 20),
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
              // SizedBox(height: 8),
              // Text(
              //   trend,
              //   style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildActionButton(
              title: 'Add Sector Admin',
              icon: Icons.person_add,
              color: Colors.blue[600]!,
              onTap: () {
                Navigator.pushNamed(context, '/create-sector-admin-screen');
              },
            ),
            _buildActionButton(
              title: 'View All Queries',
              icon: Icons.view_list,
              color: Colors.green[600]!,
              onTap: () {
                // Handle view all queries
              },
            ),
            // _buildActionButton(
            //   title: 'Generate Reports',
            //   icon: Icons.assessment,
            //   color: Colors.purple[600]!,
            //   onTap: () {
            //     // Handle generate reports
            //   },
            // ),
            // _buildActionButton(
            //   title: 'System Settings',
            //   icon: Icons.settings,
            //   color: Colors.orange[600]!,
            //   onTap: () {
            //     // Handle system settings
            //   },
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filters & Reports',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                title: 'Sector',
                value: selectedSector,
                items: [
                  'All Sectors',
                  'Healthcare',
                  'Education',
                  'Transport',
                  'Utilities',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedSector = value!;
                  });
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildDropdown(
                title: 'Time Range',
                value: selectedTimeRange,
                items: [
                  'Last 7 Days',
                  'Last 30 Days',
                  'Last 3 Months',
                  'Last Year',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedTimeRange = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(title),
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildActivityItem(
                title: _getActivityTitle(index),
                subtitle: _getActivitySubtitle(index),
                time: _getActivityTime(index),
                icon: _getActivityIcon(index),
                color: _getActivityColor(index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Text(
        time,
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
    );
  }

  String _getActivityTitle(int index) {
    switch (index) {
      case 0:
        return 'New complaint submitted';
      case 1:
        return 'Sector admin added';
      case 2:
        return 'Query resolved';
      case 3:
        return 'Report generated';
      default:
        return 'System update';
    }
  }

  String _getActivitySubtitle(int index) {
    switch (index) {
      case 0:
        return 'Healthcare sector - Water supply issue';
      case 1:
        return 'John Smith assigned to Transport sector';
      case 2:
        return 'Road maintenance complaint #1423';
      case 3:
        return 'Monthly performance report';
      default:
        return 'System maintenance completed';
    }
  }

  String _getActivityTime(int index) {
    switch (index) {
      case 0:
        return '2 min ago';
      case 1:
        return '15 min ago';
      case 2:
        return '1 hr ago';
      case 3:
        return '3 hrs ago';
      default:
        return '1 day ago';
    }
  }

  IconData _getActivityIcon(int index) {
    switch (index) {
      case 0:
        return Icons.report_problem;
      case 1:
        return Icons.person_add;
      case 2:
        return Icons.check_circle;
      case 3:
        return Icons.assessment;
      default:
        return Icons.system_update;
    }
  }

  Color _getActivityColor(int index) {
    switch (index) {
      case 0:
        return Colors.red[600]!;
      case 1:
        return Colors.blue[600]!;
      case 2:
        return Colors.green[600]!;
      case 3:
        return Colors.purple[600]!;
      default:
        return Colors.grey[600]!;
    }
  }
}
