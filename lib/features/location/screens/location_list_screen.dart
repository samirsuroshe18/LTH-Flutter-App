import 'package:complaint_portal/common_widgets/build_error_state.dart';
import 'package:complaint_portal/common_widgets/custom_loader.dart';
import 'package:complaint_portal/common_widgets/custom_snackbar.dart';
import 'package:complaint_portal/common_widgets/data_not_found_widget.dart';
import 'package:complaint_portal/common_widgets/search_filter_bar.dart';
import 'package:complaint_portal/common_widgets/single_paginated_list_view.dart';
import 'package:complaint_portal/common_widgets/staggered_list_animation.dart';
import 'package:complaint_portal/features/location/bloc/location_bloc.dart';
import 'package:complaint_portal/features/location/models/location_model.dart';
import 'package:complaint_portal/features/location/widgets/location_card.dart';
import 'package:complaint_portal/utils/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({super.key});

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Location> data = [];
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

  @override
  void initState() {
    super.initState();
    _fetchEntries();
    _scrollController.addListener(_scrollListener);
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

    context.read<LocationBloc>().add(GetLocations(queryParams: queryParams));

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

  void _showCreateLocationDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    bool isLoading = false;
    List<String> selectedSectors = [];

    final List<String> sectorOptions = [
      'Housekeeping',
      'Carpentry',
      'Telephone',
      'Electrical',
      'Technical',
      'Unsafe Condition',
      'Air Conditioning',
      'Others'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BlocConsumer<LocationBloc, LocationState>(
              listener: (context, state) {
                if(state is AddNewLocationLoading){
                  setState(() {
                    isLoading = true;
                  });
                }

                if (state is AddNewLocationSuccess) {
                  setState(() {
                    isLoading = false;
                  });
                  data.insert(0, state.response);
                  Navigator.pop(context);
                  CustomSnackBar.show(context: context, message: 'Created Successfully', type: SnackBarType.success);
                }

                if (state is AddNewLocationFailure) {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);
                  CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
                }
              },
              builder: (context, state) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create Location',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Location Name',
                                border: OutlineInputBorder(),
                              ),
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: 16),

                            // Responsive Sectors Selection
                            Text(
                              'Select Sectors',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Show selected sectors as chips
                            if (selectedSectors.isNotEmpty) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue[200]!),
                                ),
                                // child: Wrap(
                                //   spacing: 8,
                                //   runSpacing: 4,
                                //   children: selectedSectors.map((sector) {
                                //     return Chip(
                                //       label: Text(
                                //         sector,
                                //         style: const TextStyle(fontSize: 12),
                                //       ),
                                //       deleteIcon: const Icon(Icons.close, size: 16),
                                //       onDeleted: () {
                                //         setState(() {
                                //           selectedSectors.remove(sector);
                                //         });
                                //       },
                                //       backgroundColor: Colors.blue[100],
                                //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                //     );
                                //   }).toList(),
                                // ),
                                child: SizedBox(
                                  height: 40, // or 50 depending on padding
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: selectedSectors.length,
                                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                                    itemBuilder: (context, index) {
                                      final sector = selectedSectors[index];

                                      return Chip(
                                        label: Text(
                                          sector,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        deleteIcon: const Icon(Icons.close, size: 16),
                                        onDeleted: () {
                                          setState(() {
                                            selectedSectors.remove(sector);
                                          });
                                        },
                                        backgroundColor: Colors.blue[100],
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Dropdown for sector selection
                            Container(
                              width: double.infinity,
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.3,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(7),
                                        topRight: Radius.circular(7),
                                      ),
                                    ),
                                    child: Text(
                                      selectedSectors.isEmpty
                                          ? 'No sectors selected'
                                          : '${selectedSectors.length} sector(s) selected',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: selectedSectors.isEmpty ? Colors.grey[600] : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: sectorOptions.length,
                                      itemBuilder: (context, index) {
                                        final sector = sectorOptions[index];
                                        final isSelected = selectedSectors.contains(sector);

                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (isSelected) {
                                                selectedSectors.remove(sector);
                                              } else {
                                                selectedSectors.add(sector);
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: isSelected ? Colors.blue[50] : null,
                                              border: index < sectorOptions.length - 1
                                                  ? Border(bottom: BorderSide(color: Colors.grey[200]!))
                                                  : null,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                                                  color: isSelected ? Colors.blue[600] : Colors.grey[600],
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    sector,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: isSelected ? Colors.blue[800] : Colors.black87,
                                                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Responsive buttons
                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (constraints.maxWidth < 300) {
                                  // Stack buttons vertically on very small screens
                                  return Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: TextButton(
                                          onPressed: isLoading
                                              ? null
                                              : () {
                                            context.read<LocationBloc>().add(
                                                AddNewLocation(
                                                    name: nameController.text,
                                                    sectors: selectedSectors
                                                )
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            backgroundColor: isLoading ? Colors.red[300] : Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: isLoading
                                              ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Creating..',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ],
                                          )
                                              : Text(
                                            'Create',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: TextButton(
                                          onPressed: isLoading ? null : () => Navigator.pop(context),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            backgroundColor: isLoading ? Colors.grey[300] : Colors.grey[200],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  // Show buttons side by side on larger screens
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: isLoading ? null : () => Navigator.pop(context),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            backgroundColor: isLoading ? Colors.grey[300] : Colors.grey[200],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextButton(
                                          onPressed: isLoading
                                              ? null
                                              : () {
                                            context.read<LocationBloc>().add(
                                                AddNewLocation(
                                                    name: nameController.text,
                                                    sectors: selectedSectors
                                                )
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            backgroundColor: isLoading ? Colors.red[300] : Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: isLoading
                                              ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Creating..',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ],
                                          )
                                              : Text(
                                            'Create',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showEditLocationDialog(BuildContext context, Location location) {
    final TextEditingController nameController = TextEditingController(text: location.name);
    bool isLoading = false;

    // Initialize selected sectors from the location object
    List<String> selectedSectors = List<String>.from(location.sectors ?? []);

    final List<String> sectorOptions = [
      'Housekeeping',
      'Carpentry',
      'Telephone',
      'Electrical',
      'Technical',
      'Unsafe Condition',
      'Air Conditioning',
      'Others'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BlocConsumer<LocationBloc, LocationState>(
              listener: (context, state) {
                if(state is UpdateLocationLoading){
                  setState(() {
                    isLoading = true;
                  });
                }

                if (state is UpdateLocationSuccess) {
                  setState(() {
                    isLoading = false;
                  });
                  final updatedLocation = state.response;
                  final index = data.indexWhere((loc) => loc.id == updatedLocation.id);
                  if (index != -1) {
                    data[index] = updatedLocation;
                  }
                  Navigator.pop(context);
                  CustomSnackBar.show(context: context, message: 'Updated Successfully', type: SnackBarType.success);
                }

                if (state is UpdateLocationFailure) {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);
                  CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
                }
              },
              builder: (context, state) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Update Location',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Location Name',
                                border: OutlineInputBorder(),
                              ),
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: 16),

                            // Responsive Sectors Selection
                            Text(
                              'Select Sectors',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Show selected sectors as chips
                            if (selectedSectors.isNotEmpty) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue[200]!),
                                ),
                                child: SizedBox(
                                  height: 40, // or 50 depending on padding
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: selectedSectors.length,
                                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                                    itemBuilder: (context, index) {
                                      final sector = selectedSectors[index];

                                      return Chip(
                                        label: Text(
                                          sector,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        deleteIcon: const Icon(Icons.close, size: 16),
                                        onDeleted: () {
                                          setState(() {
                                            selectedSectors.remove(sector);
                                          });
                                        },
                                        backgroundColor: Colors.blue[100],
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Dropdown for sector selection
                            Container(
                              width: double.infinity,
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.3,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(7),
                                        topRight: Radius.circular(7),
                                      ),
                                    ),
                                    child: Text(
                                      selectedSectors.isEmpty
                                          ? 'No sectors selected'
                                          : '${selectedSectors.length} sector(s) selected',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: selectedSectors.isEmpty ? Colors.grey[600] : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: sectorOptions.length,
                                      itemBuilder: (context, index) {
                                        final sector = sectorOptions[index];
                                        final isSelected = selectedSectors.contains(sector);

                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (isSelected) {
                                                selectedSectors.remove(sector);
                                              } else {
                                                selectedSectors.add(sector);
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: isSelected ? Colors.blue[50] : null,
                                              border: index < sectorOptions.length - 1
                                                  ? Border(bottom: BorderSide(color: Colors.grey[200]!))
                                                  : null,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                                                  color: isSelected ? Colors.blue[600] : Colors.grey[600],
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    sector,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: isSelected ? Colors.blue[800] : Colors.black87,
                                                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Responsive buttons
                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (constraints.maxWidth < 300) {
                                  // Stack buttons vertically on very small screens
                                  return Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: TextButton(
                                          onPressed: isLoading
                                              ? null
                                              : () {
                                            context.read<LocationBloc>().add(
                                                UpdateLocation(
                                                    id: location.id!,
                                                    name: nameController.text,
                                                    sectors: selectedSectors
                                                )
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            backgroundColor: isLoading ? Colors.red[300] : Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: isLoading
                                              ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Updating..',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ],
                                          )
                                              : Text(
                                            'Update',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: TextButton(
                                          onPressed: isLoading ? null : () => Navigator.pop(context),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            backgroundColor: isLoading ? Colors.grey[300] : Colors.grey[200],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  // Show buttons side by side on larger screens
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: isLoading ? null : () => Navigator.pop(context),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            backgroundColor: isLoading ? Colors.grey[300] : Colors.grey[200],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextButton(
                                          onPressed: isLoading
                                              ? null
                                              : () {
                                            context.read<LocationBloc>().add(
                                                UpdateLocation(
                                                    id: location.id!,
                                                    name: nameController.text,
                                                    sectors: selectedSectors
                                                )
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            backgroundColor: isLoading ? Colors.red[300] : Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: isLoading
                                              ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Updating..',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ],
                                          )
                                              : Text(
                                            'Update',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showDeleteLocationDialog(BuildContext context, Location location) {
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<LocationBloc, LocationState>(
          listener: (context, state) {
            if(state is DeleteLocationLoading){
              isLoading = true;
            }

            if (state is DeleteLocationSuccess) {
              isLoading = false;
              final deletedId = state.response.id;
              data.removeWhere((loc) => loc.id == deletedId);
              Navigator.pop(context);
              CustomSnackBar.show(context: context, message: 'Deleted Successfully', type: SnackBarType.success);
            }

            if (state is DeleteLocationFailure) {
              isLoading = false;
              Navigator.pop(context);
              CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
            }
          },
          builder: (context, state) {

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 48,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Delete Location',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Are you sure you want to delete "${location.name}"?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This action cannot be undone.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: isLoading ? null : () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: isLoading ? Colors.grey[300] : Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                              context.read<LocationBloc>().add(DeleteLocation(id: location.id!));
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: isLoading ? Colors.red[300] : Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: isLoading
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Deleting..',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                                : Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
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

  Future<void> _downloadLocationPDF(Location location) async {

    CustomSnackBar.show(context: context, message: 'Downloading PDF...', type: SnackBarType.info);

    final success = await PdfService.downloadLocationPDF(location.id!, location.name ?? 'N/A', context);

    if (success) {
      CustomSnackBar.show(context: context, message: 'PDF downloaded successfully!', type: SnackBarType.success);
    } else {
      CustomSnackBar.show(context: context, message: 'Failed to download PDF', type: SnackBarType.error);
    }
  }

  Future<void> _downloadAllLocationsPDF() async {
    if (data.isEmpty) {
      CustomSnackBar.show(context: context, message: 'No locations available to download', type: SnackBarType.error);
      return;
    }

    CustomSnackBar.show(context: context, message: 'Downloading all locations PDF...', type: SnackBarType.info);

    final success = await PdfService.downloadAllLocationsPDF(context);

    if (success) {
      CustomSnackBar.show(context: context, message: 'All locations PDF downloaded successfully!', type: SnackBarType.success);
    } else {
      CustomSnackBar.show(context: context, message: 'Failed to download PDF', type: SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Location QR Manager'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SearchFilterBar(
            searchController: _searchController,
            hintText: 'Search by location name, id, etc.',
            searchQuery: _searchQuery,
            onSearchSubmitted: _onSearchSubmitted,
            onClearSearch: _onClearSearch,
            isFilterButton: false,
            hasActiveFilters: _hasActiveFilters,
            onFilterPressed: () => _showFilterBottomSheet(context),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _onRefresh,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'download_all') {
                _downloadAllLocationsPDF();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'download_all',
                child: Row(
                  children: [
                    Icon(Icons.download, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Download All PDFs',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state){
          /// Get all locations
          if(state is GetLocationsLoading){
            _isLoading = true;
            _isError = false;
          }
          if(state is GetLocationsSuccess){
            if (state.response.pagination?.currentPage == 1) {
              data.clear();
              _page=1;
            }
            data.addAll(state.response.locations as Iterable<Location>);
            _page++;
            _hasMore = state.response.pagination?.hasMore ?? false;
            _isLoading = false;
            _isLazyLoading = false;
            _isError = false;
          }
          if(state is GetLocationsFailure){
            data = [];
            _isLoading = false;
            _isLazyLoading = false;
            _isError = true;
            statusCode= state.status;
            _hasMore = false;
          }
        },
        builder: (state, context){
          if (data.isNotEmpty && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: AnimationLimiter(
                child: SinglePaginatedListView<Location>(
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
                child: SinglePaginatedListView<Location>(
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
            return DataNotFoundWidget(
              onRefresh: _onRefresh,
              title: "No Service Areas Configured",
              subtitle: "No service locations have been set up yet. Configure service areas and zones to manage your coverage effectively.",
              buttonText: "Refresh Locations",
              customIcon: Icons.location_on_outlined,
              primaryColor: Colors.blue,
              animationSize: 180,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_showCreateLocationDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _itemBuilder(item, index) {
    return StaggeredListAnimation(
      index: index,
      child: LocationCard(
        location: item,
        onEdit: () => _showEditLocationDialog(context, item),
        onDelete: () => _showDeleteLocationDialog(context, item),
        onDownloadPDF: () => _downloadLocationPDF(item),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _page=1;
    await _fetchEntries();
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
}
