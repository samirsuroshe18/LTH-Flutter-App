import 'package:complaint_portal/common_widgets/custom_snackbar.dart';
import 'package:complaint_portal/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuperAdminHome extends StatefulWidget {
  const SuperAdminHome({super.key});

  @override
  State<SuperAdminHome> createState() => _SuperAdminHomeState();
}

class _SuperAdminHomeState extends State<SuperAdminHome> {
  String selectedSector = 'All Sectors';
  String selectedTimeRange = 'Last 30 Days';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
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
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.dashboard,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Text(
            'ComplaintDesk',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        // Container(
        //   margin: EdgeInsets.only(right: 16),
        //   child: CircleAvatar(
        //     backgroundColor: Colors.blue[100],
        //     child: Icon(
        //       Icons.person,
        //       color: Colors.blue[600],
        //       size: 20,
        //     ),
        //   ),
        // ),
        // Profile Icon/Image in top right
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  enabled: false,
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        "Samir",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ];
            },
            child: Container(
              margin: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Icon(
                  Icons.person,
                  color: Colors.blue[600],
                  size: 20,
                ),
              ),
            ),
          ),
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
          childAspectRatio: 1,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildStatCard(
              title: 'Total Sector Admins',
              value: '24',
              icon: Icons.admin_panel_settings,
              color: Colors.blue[600]!,
              trend: '+3 this month',
            ),
            _buildStatCard(
              title: 'Pending Queries',
              value: '142',
              icon: Icons.pending_actions,
              color: Colors.orange[600]!,
              trend: '-12 from yesterday',
            ),
            _buildStatCard(
              title: 'Resolved Queries',
              value: '1,847',
              icon: Icons.check_circle,
              color: Colors.green[600]!,
              trend: '+89 this week',
            ),
            _buildStatCard(
              title: 'Active Sectors',
              value: '18',
              icon: Icons.domain,
              color: Colors.purple[600]!,
              trend: 'All operational',
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
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // radius here
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
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
            SizedBox(height: 8),
            Text(
              trend,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildStatCard({
  //   required String title,
  //   required String value,
  //   required IconData icon,
  //   required Color color,
  //   required String trend,
  // }) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withValues(alpha: 0.1),
  //           spreadRadius: 1,
  //           blurRadius: 6,
  //           offset: Offset(0, 3),
  //         ),
  //       ],
  //     ),
  //     padding: EdgeInsets.all(16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Container(
  //               padding: EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: color.withValues(alpha: 0.1),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: Icon(
  //                 icon,
  //                 color: color,
  //                 size: 20,
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 12),
  //         Text(
  //           value,
  //           style: TextStyle(
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.grey[800],
  //           ),
  //         ),
  //         SizedBox(height: 4),
  //         Text(
  //           title,
  //           style: TextStyle(
  //             fontSize: 12,
  //             color: Colors.grey[600],
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //         SizedBox(height: 8),
  //         Text(
  //           trend,
  //           style: TextStyle(
  //             fontSize: 10,
  //             color: Colors.grey[500],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
                // Handle add sector admin
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
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
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
                items: ['All Sectors', 'Healthcare', 'Education', 'Transport', 'Utilities'],
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
                items: ['Last 7 Days', 'Last 30 Days', 'Last 3 Months', 'Last Year'],
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
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
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
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
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
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[500],
        ),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LogoutDialog();
      },
    );
  }
}

class LogoutDialog extends StatefulWidget {
  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutSuccess) {
          _isLoading = false;
          // Close the dialog
          Navigator.of(context).pop();
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
                (route) => false,
          );
        }
        if (state is AuthLogoutFailure) {
          _isLoading = false;
          CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
        }
        if (state is AuthLogoutLoading) {
          _isLoading = true;
        }
      },
      builder: (context, state){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.orange,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to logout?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'You will need to sign in again to access your account.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _isLoading ? null : () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : () {
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: _isLoading
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('Logging out...'),
                ],
              )
                  : Text(
                'OK',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      }
    );
  }

  void _performLogout() async {
    context.read<AuthBloc>().add(AuthLogout());
  }

  void _showLogoutSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Logged out successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}