import 'dart:convert';

import 'package:complaint_portal/common_widgets/build_error_state.dart';
import 'package:complaint_portal/common_widgets/custom_loader.dart';
import 'package:complaint_portal/common_widgets/custom_snackbar.dart';
import 'package:complaint_portal/common_widgets/data_not_found_widget.dart';
import 'package:complaint_portal/common_widgets/grouped_paginated_list_view.dart';
import 'package:complaint_portal/common_widgets/search_filter_bar.dart';
import 'package:complaint_portal/common_widgets/staggered_list_animation.dart';
import 'package:complaint_portal/features/auth/bloc/auth_bloc.dart';
import 'package:complaint_portal/features/auth/models/user_model.dart';
import 'package:complaint_portal/features/notice/models/notice_board_model.dart';
import 'package:complaint_portal/features/technician_home/bloc/technician_home_bloc.dart';
import 'package:complaint_portal/features/technician_home/models/technician_complaint_model.dart';
import 'package:complaint_portal/features/technician_home/widgets/assign_complaint_card.dart';
import 'package:complaint_portal/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';

class TechnicianHome extends StatefulWidget {
  const TechnicianHome({super.key});

  @override
  State<TechnicianHome> createState() => _TechnicianHomeState();
}

class _TechnicianHomeState extends State<TechnicianHome> {
  NotificationAppLaunchDetails? notificationAppLaunchDetails;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<AssignComplaint> data = [];
  bool _isLoading = false;
  bool _isStartWork = false;
  bool _isLazyLoading = false;
  bool _isError = false;
  int? statusCode;
  String? errorMessage;
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  String _searchQuery = '';
  String _selectedStatus = '';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _hasActiveFilters = false;
  BuildContext? _dialogContext;
  UserModel? user;

  void getInitialAction() async {
    notificationAppLaunchDetails = NotificationController.notificationAppLaunchDetails;
    Map<String, dynamic>? payload;
    if(notificationAppLaunchDetails?.notificationResponse?.payload != null){
      payload = jsonDecode(notificationAppLaunchDetails!.notificationResponse!.payload!);
    }
    if (mounted ) {
      if (notificationAppLaunchDetails != null && payload?['action'] == 'NOTIFY_NOTICE') {
        Navigator.pushNamedAndRemoveUntil(context, '/notice-detail-screen', (route) => route.isFirst, arguments: Notice.fromJson(jsonDecode(payload?['noticeData'])));
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
    _fetchEntries();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInitialAction();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore && data.length>=_limit) {
        _isLazyLoading = true;
        _fetchEntries();
      }
    }
  }

  Future<void> _fetchEntries()async {
    final queryParams = {
      'page': _page.toString(),
      'limit': _limit.toString(),
    };

    if (_searchQuery.isNotEmpty) {
      queryParams['search'] = _searchQuery;
    }

    if (_selectedStatus.isNotEmpty) {
      queryParams['status'] = _selectedStatus;
    }

    if (_startDate != null) {
      queryParams['startDate'] = DateFormat('yyyy-MM-dd').format(_startDate!);
    }

    if (_endDate != null) {
      queryParams['endDate'] = DateFormat('yyyy-MM-dd').format(_endDate!);
    }

    context.read<TechnicianHomeBloc>().add(GetAssignComplaints(queryParams: queryParams));
  }

  void _applyFilters() {
    setState(() {
      _page = 1;
      _hasMore = true;
      data.clear();
      _hasActiveFilters = _selectedStatus.isNotEmpty || _startDate != null || _endDate != null;
    });
    _fetchEntries();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) {
      return 'Today';
    } else if (entryDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }

  void _onSearchSubmitted(value) {
    setState(() {
      _searchQuery = value;
      _page = 1;
      data.clear();
    });
    _fetchEntries();
  }

  void _onClearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _page = 1;
      data.clear();
    });
    _fetchEntries();
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Entries',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _selectedStatus = '';
                              _startDate = null;
                              _endDate = null;
                            });
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Entry Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildFilterChip('Pending', 'pending', setModalState),
                        _buildFilterChip('Under Review', 'under_review', setModalState),
                        _buildFilterChip('In Progress', 'in_progress', setModalState),
                        _buildFilterChip('Resolved', 'approved', setModalState),
                        _buildFilterChip('Rejected', 'rejected', setModalState),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Date Range',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        await _selectDateRange(context);
                        setModalState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.date_range),
                            const SizedBox(width: 8),
                            Text(
                              _startDate != null && _endDate != null
                                  ? '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d').format(_endDate!)}'
                                  : 'Select date range',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        // Cancel button
                        Expanded(
                          child: SizedBox(
                            height: 48, // Equal height for both buttons
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48, // Same height
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _applyFilters();
                              },
                              child: const Text('Apply'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String label, String value, StateSetter setModalState) {
    return FilterChip(
      label: Text(label),
      selected: _selectedStatus == value,
      onSelected: (selected) {
        setModalState(() {
          _selectedStatus = selected ? value : '';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Assigned Queries',
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
                value: 'stats',
                child: Row(
                  children: [
                    Icon(Icons.analytics, color: Colors.grey[700]),
                    SizedBox(width: 12),
                    Text('My Statistics'),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SearchFilterBar(
            searchController: _searchController,
            hintText: 'Search by complaint id and sectors.',
            searchQuery: _searchQuery,
            onSearchSubmitted: _onSearchSubmitted,
            onClearSearch: _onClearSearch,
            isFilterButton: true,
            hasActiveFilters: _hasActiveFilters,
            onFilterPressed: () => _showFilterBottomSheet(context),
          ),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state){
          if(state is AuthLogoutLoading){
            showLoadingDialog(context);
          }
          if(state is AuthLogoutSuccess){
            Future.delayed(const Duration(seconds: 1), () {
              dismissLoadingDialog();
              CustomSnackBar.show(
                context: context,
                message: "Logout Successfully.",
                type: SnackBarType.success,
              );
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            });
          }
          if(state is AuthLogoutFailure){
            Future.delayed(const Duration(seconds: 1), () {
              dismissLoadingDialog();
              CustomSnackBar.show(
                context: context,
                message: state.message,
                type: SnackBarType.error,
              );
            });
          }
        },
        builder: (context, state){
          return BlocConsumer<TechnicianHomeBloc, TechnicianHomeState>(
            listener: (context, state){
              if(state is GetAssignComplaintsLoading){
                setState(() {
                  _isLoading = true;
                });
                _isError = false;
              }
              if(state is GetAssignComplaintsSuccess){
                if (_page == 1) {
                  data.clear();
                }
                data.addAll(state.response.technicianComplaints as Iterable<AssignComplaint>);
                _page++;
                _hasMore = state.response.pagination?.hasMore ?? false;
                setState(() {
                  _isLoading = false;
                });
                _isLazyLoading = false;
                _isError = false;
              }
              if(state is GetAssignComplaintsFailure){
                data = [];
                setState(() {
                  _isLoading = false;
                });
                _isLazyLoading = false;
                _isError = true;
                statusCode= state.status;
                errorMessage= state.message;
                _hasMore = false;
              }
              if(state is StartWorkLoading){
                _isStartWork = true;
                _isError = false;
              }
              if(state is StartWorkSuccess){
                _isStartWork = false;
                _isError = false;
                final updatedComplaint = state.response; // Assuming this is your updated item
                final index = data.indexWhere((item) => item.id == updatedComplaint.id);

                if (index != -1) {
                  data[index] = updatedComplaint;
                  // setState(() {}); // If you're in a StatefulWidget and want to refresh UI
                }
              }
              if(state is StartWorkFailure){
                _isStartWork = false;
                _isError = true;
                statusCode = state.status;
                errorMessage = state.message;
              }
            },
            builder: (context, state){
              if (data.isNotEmpty && _isLoading == false) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: AnimationLimiter(
                    child: GroupedPaginatedListView<AssignComplaint>(
                      groupedData: _getGroupedData(),
                      controller: _scrollController,
                      hasMore: _hasMore,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      groupHeaderBuilder: _groupHeaderBuilder,
                      itemBuilder: _itemBuilder,
                    ),
                  ),
                );
              } else if (_isLazyLoading) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: AnimationLimiter(
                    child: GroupedPaginatedListView<AssignComplaint>(
                      groupedData: _getGroupedData(),
                      controller: _scrollController,
                      hasMore: _hasMore,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      groupHeaderBuilder: _groupHeaderBuilder,
                      itemBuilder: _itemBuilder,
                    ),
                  ),
                );
              } else if (_isLoading && _isLazyLoading==false) {
                return const CustomLoader();
              } else if (data.isEmpty && _isError == true && statusCode == 401) {
                return BuildErrorState(onRefresh: _onRefresh, errorMessage: errorMessage,);
              } else if (_isError == true && statusCode == 403) {
                return BuildErrorState(onRefresh: _onRefresh, errorMessage: errorMessage,);
              } else {
                return DataNotFoundWidget(
                  onRefresh: _onRefresh,
                  title: "No Complaints Assigned",
                  subtitle: "There are no complaints currently assigned to you. New complaints will appear here once they're assigned to you.",
                  buttonText: "Refresh Assignments",
                  customIcon: Icons.assignment_outlined,
                  primaryColor: Colors.blue,
                  animationSize: 180,
                );
              }
            },
          );
        },
      ),
    );
  }

  void _handleProfileMenuSelection(String value) {
    switch (value) {
      case 'profile':
        _showProfileDialog();
        break;
      case 'stats':
        _showStatsDialog();
        break;
      case 'change_password':
        Navigator.pushNamed(context, '/change-password');
        break;
      case 'logout':
        _showLogoutDialog();
        break;
    }
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
                          value: user?.technicianType ?? 'Not Available',
                          color: Colors.green,
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

  void _showStatsDialog() {
    // Calculate stats from current complaints
    final totalComplaints = data.length;
    final resolved = data.where((c) => c.status == 'Resolved').length;
    final inProgress = data.where((c) => c.status == 'In Progress').length;
    final pending = data.where((c) => c.status == 'Pending').length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.analytics, color: Color(0xFF2E3B4E)),
              SizedBox(width: 12),
              Text(
                'My Statistics',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatCard('Total Assigned', totalComplaints.toString(), Colors.blue),
              SizedBox(height: 8),
              _buildStatCard('Resolved', resolved.toString(), Colors.green),
              SizedBox(height: 8),
              _buildStatCard('In Progress', inProgress.toString(), Colors.orange),
              SizedBox(height: 8),
              _buildStatCard('Pending', pending.toString(), Colors.red),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Completion Rate',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      totalComplaints > 0
                          ? '${((resolved / totalComplaints) * 100).toStringAsFixed(1)}%'
                          : '0%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
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
              Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
                context.read<AuthBloc>().add(AuthLogout()); // Then trigger logout
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

  Future<void> _onRefresh() async {
    _page = 1;
    await _fetchEntries();
  }

  Map<String, List<AssignComplaint>> _getGroupedData(){
    // Group entries by date
    final Map<String, List<AssignComplaint>> groupedEntries = {};

    for (var entry in data) {
      final String dateKey = _formatDate(entry.assignedAt!);

      if (!groupedEntries.containsKey(dateKey)) {
        groupedEntries[dateKey] = [];
      }

      groupedEntries[dateKey]!.add(entry);
    }
    return groupedEntries;
  }

  Widget _groupHeaderBuilder(date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        date,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
        ),
      ),
    );
  }

  Widget _itemBuilder(complaint, index) {
    AssignComplaint item = complaint;
    return StaggeredListAnimation(
      index: index,
      child: AssignComplaintCard(
        data: complaint,
        onStartWork: () => _startWork(item),
        onSubmit: () => _onSubmit(item),
        isStartLoading: _isStartWork,
      ),
    );
  }

  void _startWork(AssignComplaint data){
    context.read<TechnicianHomeBloc>().add(StartWork(id: data.id!));
  }

  Future<void> _onSubmit(AssignComplaint item) async {
    final response = await Navigator.pushNamed(
      context,
      '/submit-resolution',
      arguments: item,
    );

    if (response is AssignComplaint) {
      final index = data.indexWhere((e) => e.id == response.id);

      if (index != -1) {
        setState(() {
          data[index] = response;
        });
      }
    }
  }

  void showResolutionDialog({required BuildContext context, required String? imageUrl, required String resolutionNote,}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image Preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl != null
                      ? Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey[500]),
                  ),
                ),
                const SizedBox(height: 20),

                // Resolution Note
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Resolution Note',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  constraints: BoxConstraints(
                    maxHeight: 200,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      resolutionNote.isNotEmpty
                          ? resolutionNote
                          : 'No resolution note provided.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}