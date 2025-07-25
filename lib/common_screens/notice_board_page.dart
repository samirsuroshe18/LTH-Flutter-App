import 'package:complaint_portal/features/auth/bloc/auth_bloc.dart';
import 'package:complaint_portal/features/auth/models/user_model.dart';
import 'package:complaint_portal/features/super_admin_home/bloc/super_admin_home_bloc.dart';
import 'package:complaint_portal/features/super_admin_home/models/notice_board_model.dart';
import 'package:complaint_portal/features/super_admin_home/widgets/NoticeCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:complaint_portal/common_widgets/build_error_state.dart';
import 'package:complaint_portal/common_widgets/custom_loader.dart';
import 'package:complaint_portal/common_widgets/data_not_found_widget.dart';
import 'package:complaint_portal/common_widgets/search_filter_bar.dart';
import 'package:complaint_portal/common_widgets/single_paginated_list_view.dart';
import 'package:complaint_portal/common_widgets/staggered_list_animation.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class NoticeBoardPage extends StatefulWidget {
  const NoticeBoardPage({super.key});
  @override
  State<NoticeBoardPage> createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Notice> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;
  bool _isLazyLoading = false;
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  String _searchQuery = '';
  String _selectedCategory = '';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _hasActiveFilters = false;
  late final AuthBloc authBloc;
  UserModel? user;
  String? role;

  @override
  void initState() {
    super.initState();
    _fetchEntries();
    _scrollController.addListener(_scrollListener);
    authBloc = context.read<AuthBloc>();
    user = authBloc.currentUser;
    if (user != null) {
      role = user?.role;
    }
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

    if (_selectedCategory.isNotEmpty) {
      queryParams['category'] = _selectedCategory;
    }

    if (_startDate != null) {
      queryParams['startDate'] = DateFormat('yyyy-MM-dd').format(_startDate!);
    }

    if (_endDate != null) {
      queryParams['endDate'] = DateFormat('yyyy-MM-dd').format(_endDate!);
    }

    context.read<SuperAdminHomeBloc>().add(NoticeBoardGetAllNotices(queryParams: queryParams));
  }

  void _applyFilters() {
    setState(() {
      _page = 1;
      _hasMore = true;
      data.clear();
      _hasActiveFilters = _selectedCategory.isNotEmpty || _startDate != null || _endDate != null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'Notice Board',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _onRefresh,
            tooltip: 'Refresh Notices',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SearchFilterBar(
            searchController: _searchController,
            hintText: 'Search by name, mobile, etc.',
            searchQuery: _searchQuery,
            onSearchSubmitted: _onSearchSubmitted,
            onClearSearch: _onClearSearch,
            isFilterButton: true,
            hasActiveFilters: _hasActiveFilters,
            onFilterPressed: () => _showFilterBottomSheet(context),
          ),
        ),
      ),
      body: BlocConsumer<SuperAdminHomeBloc, SuperAdminHomeState>(
        listener: (context, state) {
          if (state is NoticeBoardGetAllNoticesLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is NoticeBoardGetAllNoticesSuccess) {
            if (state.response.pagination?.currentPage == 1) {
              data.clear();
              _page=1;
            }
            data.addAll(state.response.notices as Iterable<Notice>);
            _page++;
            _hasMore = state.response.pagination?.hasMore ?? false;
            _isLoading = false;
            _isLazyLoading = false;
            _isError = false;
          }
          if (state is NoticeBoardGetAllNoticesFailure) {
            data = [];
            _isLoading = false;
            _isLazyLoading = false;
            _isError = true;
            statusCode= state.status;
            _hasMore = false;
          }
        },
        builder: (context, state) {
          if (data.isNotEmpty && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: AnimationLimiter(
                child: SinglePaginatedListView<Notice>(
                  data: data,
                  controller: _scrollController,
                  hasMore: _hasMore,
                  itemBuilder: _itemBuilder,
                ),
              ),
            );
          } else if (_isLazyLoading) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: AnimationLimiter(
                child: SinglePaginatedListView<Notice>(
                  data: data,
                  controller: _scrollController,
                  hasMore: _hasMore,
                  itemBuilder: _itemBuilder,
                ),
              ),
            );
          } else if (_isLoading && _isLazyLoading==false) {
            return const CustomLoader();
          }else if (data.isEmpty && _isError == true && statusCode == 401) {
            return BuildErrorState(onRefresh: _onRefresh);
          } else {
            return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: "There are no notices",);
          }
        },
      ),
      floatingActionButton: role == 'superadmin' ? FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/create-notice-screen');
          if (result != null && result is Notice) {
            setState(() {
              data.insert(0, result); // Insert at top
            });

            // Scroll to top after short delay to let the UI update
            Future.delayed(Duration(milliseconds: 100), () {
              _scrollController.animateTo(
                0.0,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          }
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white70),
      ) : null,
    );
  }

  Widget _itemBuilder(item, index) {
    return StaggeredListAnimation(
      index: index,
      child: NoticeCard(
        data: item,
        onTap: ()=> _onTap(index),
      ),
    );
  }

  Future<void> _onTap (int index)async {
    final result = await Navigator.pushNamed(context, '/notice-detail-screen', arguments: data[index]);
    if (result != null && result is Notice) {
      setState(() {
        data[index] = result;
      });
      _scrollToIndex(index);
    }

    if (result == true) {
      setState(() {
        data.removeAt(index);
      });
      _scrollToIndex(index);
    }
  }

  void _scrollToIndex(int index) {
    // Estimate item height if fixed, or use scrollable_positioned_list for variable height
    double itemHeight = 200.0; // adjust to your item height
    double offset = index * itemHeight;

    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
                              _selectedCategory = '';
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

  Future<void> _onRefresh() async {
    _page=1;
    await _fetchEntries();
  }
}