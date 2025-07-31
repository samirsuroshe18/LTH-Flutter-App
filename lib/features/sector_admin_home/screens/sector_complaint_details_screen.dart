import 'package:complaint_portal/common_widgets/build_error_state.dart';
import 'package:complaint_portal/common_widgets/custom_cached_network_image.dart';
import 'package:complaint_portal/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:complaint_portal/common_widgets/custom_loader.dart';
import 'package:complaint_portal/common_widgets/custom_snackbar.dart';
import 'package:complaint_portal/features/sector_admin_home/bloc/sector_admin_home_bloc.dart';
import 'package:complaint_portal/features/sector_admin_home/models/sector_complaint_model.dart';
import 'package:complaint_portal/features/sector_admin_home/models/technician_model.dart';
import 'package:complaint_portal/features/super_admin_home/widgets/action_button_widget.dart';
import 'package:complaint_portal/features/super_admin_home/widgets/reopen_button.dart';
import 'package:complaint_portal/features/super_admin_home/widgets/resolution_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class SectorComplaintDetailsScreen extends StatefulWidget {
  final String? complaintId;
  final SectorComplaint? data;

  const SectorComplaintDetailsScreen({super.key, required this.data, this.complaintId});

  @override
  State<SectorComplaintDetailsScreen> createState() => _SectorComplaintDetailsScreenState();
}

class _SectorComplaintDetailsScreenState extends State<SectorComplaintDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool isResolved = false;
  final ScrollController _scrollController = ScrollController();
  SectorComplaint? complaintModel;
  late String userId;
  bool _isLoading = false;
  bool _isProcessing = false;
  bool _isResolvedLoading = false;
  bool _isRejectLoading = false;
  bool _isSaveLoading = false;
  bool _isError = false;
  String? errorMessage;
  int? statusCode;
  String complaintId = "...";
  DateTime? complaintDate;
  Technician? _assignedTechnician;
  String? resolutionStatus;

  @override
  void initState() {
    super.initState();
    if(widget.data!=null){
      complaintModel = widget.data;
      context.read<SectorAdminHomeBloc>().add(GetSectorComplaintDetails(id: widget.data!.id!));
    }else{
      context.read<SectorAdminHomeBloc>().add(GetSectorComplaintDetails(id: widget.complaintId!));
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    if(widget.data!=null){
      context.read<SectorAdminHomeBloc>().add(GetSectorComplaintDetails(id: widget.data!.id!));
    }else{
      context.read<SectorAdminHomeBloc>().add(GetSectorComplaintDetails(id: widget.complaintId!));
    }
  }

  void _navigateAndSelectTechnician() async {
    if(complaintModel != null){
      final selected = await Navigator.pushNamed(context, '/sector-selection-screen', arguments: complaintModel);
      if (selected != null && selected is Technician) {
        setState(() {
          _assignedTechnician = selected;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, setResult) {
        if (!didPop) {
          Navigator.of(context).pop(complaintModel);
        }
        // If didPop is true, the pop already happened, so usually nothing to do.
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complaint #$complaintId',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                complaintDate != null
                    ? DateFormat('MMMM d, yyyy').format(complaintDate!)
                    : 'NA',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, complaintModel),
          ),
          actions: [
            _buildStatusChip(complaintModel?.status ?? 'NA'),
            const SizedBox(width: 16),
          ],
        ),
        body: BlocConsumer<SectorAdminHomeBloc, SectorAdminHomeState>(
          listener: _blocListener,
          builder: (context, state) {
            if (complaintModel != null && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: Colors.blue,
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildComplaintHeader(Colors.white, Colors.black87, Colors.grey[600]!),
                            const SizedBox(height: 16),
                            _buildComplaintDetails(Colors.white, Colors.black87, Colors.grey[600]!),
                            const SizedBox(height: 16),
                            _buildTechnicianSection(Colors.white, Colors.black87, Colors.grey[600]!),
                            const SizedBox(height: 16),
                            if(complaintModel?.status != 'Pending' && complaintModel?.resolution?.status == 'under_review' || complaintModel?.status == 'Rejected' || complaintModel?.status == 'Resolved')
                            _buildResolutionStatus(Colors.white, Colors.black87, Colors.grey[600]!),
                            const SizedBox(height: 16), // Space for bottom navigation
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (_isLoading) {
              return const CustomLoader();
            } else if (_isError == true && statusCode == 403 || statusCode == 401) {
              return BuildErrorState(onRefresh: _onRefresh, errorMessage: errorMessage,);
            }  else {
              return BuildErrorState(onRefresh: _onRefresh);
            }
          },
        ),
        bottomNavigationBar: _buildBottomSection(),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;
    String label;
    IconData icon;

    switch (status) {
      case 'Resolved':
        chipColor = Colors.green.shade400;
        textColor = Colors.white;
        label = 'Resolved';
        icon = Icons.check_circle;
        break;
      case 'Pending':
        chipColor = Colors.orange.shade400;
        textColor = Colors.white;
        label = 'Pending';
        icon = Icons.access_time;
        break;
      case 'In Progress':
        chipColor = Colors.blue.shade400;
        textColor = Colors.white;
        label = 'In Progress';
        icon = Icons.sync;
        break;
      case 'Rejected':
        chipColor = Colors.red.shade400;
        textColor = Colors.white;
        label = 'Rejected';
        icon = Icons.cancel;
        break;
      default:
        chipColor = Colors.grey.shade400;
        textColor = Colors.white;
        label = 'Unknown';
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: chipColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: textColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintHeader(Color cardColor, Color textColor, Color subtextColor) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.3), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomCachedNetworkImage(
                      size: 60,
                      borderWidth: 0,
                      errorImage: Icons.report_problem_outlined,
                      isCircular: false,
                      imageUrl: complaintModel?.image,
                      onTap: () => CustomFullScreenImageViewer.show(
                        context,
                        complaintModel?.image,
                        errorImage: Icons.report_problem_outlined,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.category, // You can change this to match the category type
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              complaintModel?.sector ?? 'NA',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: subtextColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              complaintModel?.location?.name ?? 'NA',
                              style: TextStyle(
                                fontSize: 14,
                                color: subtextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintDetails(Color cardColor, Color textColor, Color subtextColor) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.description, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Complaint Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.dashboard, 'Sector', complaintModel?.sector ?? 'NA', subtextColor, textColor),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.notes, 'Description', complaintModel?.description ?? 'NA', subtextColor, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String content, Color subtextColor, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: subtextColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: subtextColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTechnicianSection(Color cardColor, Color textColor, Color subtextColor) {
    return Card(
      elevation: 2,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.engineering, color: Colors.deepPurple, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Technician Assignment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAssignedTechnicianInfo(textColor, subtextColor),
          ],
        ),
      ),
    );
  }

  Widget _buildResolutionStatus(Color cardColor, Color textColor, Color subtextColor) {
    if (resolutionStatus == 'pending') return const SizedBox.shrink();

    return Card(
      elevation: 2,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.task_alt, color: Colors.green, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Resolution Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (resolutionStatus != 'pending')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showResolutionDialog(context),
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('View Resolution'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showResolutionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ResolutionDetailsDialog(
        imageUrl: complaintModel?.resolution?.resolutionAttachment ?? '',
        resolutionNote: complaintModel?.resolution?.resolutionNote ?? '',
        timestamp: complaintModel?.resolution?.resolutionSubmittedAt,
        isNetworkImage: true,
      ),
    );
  }

  Widget _buildAssignedTechnicianInfo(Color textColor, Color subtextColor) {
    if (complaintModel?.assignStatus == 'unassigned') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No technician assigned yet',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _navigateAndSelectTechnician,
              icon: const Icon(Icons.person_add, size: 18),
              label: const Text('Assign Technician'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
            ),
          ),

          if (_assignedTechnician != null) ...[
            const SizedBox(height: 16),
            _buildTechnicianCard(_assignedTechnician!, textColor, subtextColor, isSelected: true),
          ],
        ],
      );
    }

    if (complaintModel?.assignStatus == 'assigned') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Technician assigned successfully',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildTechnicianCard(
            Technician(
              id: complaintModel?.assignedWorker?.id,
              userName: complaintModel?.assignedWorker?.userName,
              role: complaintModel?.assignedWorker?.role,
            ),
            textColor,
            subtextColor,
          ),
          const SizedBox(height: 16),
          if (complaintModel?.status != 'resolved')
            _buildResolutionStatusCard(textColor, subtextColor),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildTechnicianCard(Technician technician, Color textColor, Color subtextColor, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.blue.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: CustomCachedNetworkImage(
              isCircular: true,
              size: 40,
              imageUrl: null,
              errorImage: Icons.person,
              borderWidth: 0,
              onTap: () => CustomFullScreenImageViewer.show(context, null, errorImage: Icons.person),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  technician.userName ?? 'NA',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.work_outline, size: 14, color: subtextColor),
                    const SizedBox(width: 4),
                    Text(
                      technician.role ?? 'NA',
                      style: TextStyle(
                        color: subtextColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isSelected && complaintModel?.assignStatus == 'unassigned')
            SizedBox(
              height: 36,
              child: ElevatedButton.icon(
                onPressed: _isSaveLoading ? null : () {
                  context.read<SectorAdminHomeBloc>().add(
                    SectorAssignTechnician(
                      complaintId: complaintModel!.id!,
                      assignedWorker: _assignedTechnician!.id!,
                    ),
                  );
                },
                icon: _isSaveLoading
                    ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Icon(Icons.save, size: 16),
                label: Text(_isSaveLoading ? 'Saving...' : 'Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResolutionStatusCard(Color textColor, Color subtextColor) {
    final status = complaintModel?.resolution?.status ?? 'pending';
    final statusColor = _getStatusColorForText(status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _getStatusIcon(status),
              color: statusColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusTitle(status),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusMessage(status),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'under_review':
        return Icons.rate_review;
      case 'pending':
        return Icons.schedule;
      default:
        return Icons.help;
    }
  }

  String _getStatusTitle(String status) {
    switch (status) {
      case 'approved':
        return 'Resolution Approved';
      case 'rejected':
        return 'Rework Required';
      case 'under_review':
        return 'Under Review';
      case 'pending':
        return 'Pending Resolution';
      default:
        return 'Unknown Status';
    }
  }

  Color _getStatusColorForText(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'under_review':
        return Colors.orange;
      case 'pending':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'approved':
        return 'Complaint resolution approved. Awaiting resident action.';
      case 'rejected':
        return 'Rework requested. Awaiting technician action.';
      case 'under_review':
        return 'Complaint resolution pending review.';
      case 'pending':
        return 'Awaiting complaint resolution from technician.';
      default:
        return 'Awaiting complaint resolution from technician.';
    }
  }

  void _blocListener(BuildContext context, SectorAdminHomeState state) {
    if (state is SectorAssignTechnicianLoading) {
      _isSaveLoading = true;
      _isError = false;
    }
    if (state is SectorAssignTechnicianSuccess) {
      _isSaveLoading = false;
      _isError = false;
      complaintModel = state.response;
      resolutionStatus = complaintModel?.resolution?.status ?? 'pending';
      setState(() {
        isResolved = complaintModel!.status != 'Pending';
        complaintId = complaintModel!.complaintId!;
        complaintDate = complaintModel!.createdAt!;
      });
    }
    if (state is SectorAssignTechnicianFailure) {
      _isSaveLoading = false;
      _isError = true;
      statusCode = state.status;
      errorMessage = state.message;
      CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
    }

    if (state is SectorApproveResolutionLoading) {
      _isError = false;
      setState(() {
        _isResolvedLoading = true;
      });
    }
    if (state is SectorApproveResolutionSuccess) {
      _isError = false;
      setState(() {
        _isResolvedLoading = false;
        complaintModel = state.response;
        isResolved = state.response.status == 'Resolved';
      });
    }
    if (state is SectorApproveResolutionFailure) {
      _isError = true;
      statusCode = state.status;
      errorMessage = state.message;
      setState(() {
        _isResolvedLoading = false;
      });
      _showErrorSnackBar(state.message);
    }

    if (state is SectorRejectResolutionLoading) {
      _isError = false;
      setState(() {
        _isRejectLoading = true;
      });
    }
    if (state is SectorRejectResolutionSuccess) {
      _isError = false;
      setState(() {
        _isRejectLoading = false;
        complaintModel = state.response;
        isResolved = state.response.status == 'Resolved';
      });
    }
    if (state is SectorRejectResolutionFailure) {
      _isError = true;
      statusCode = state.status;
      errorMessage = state.message;
      setState(() {
        _isRejectLoading = false;
      });
      _showErrorSnackBar(state.message);
    }

    if (state is GetSectorComplaintDetailsLoading) {
      _isError = false;
      setState(() {
        _isLoading = true;
      });
    }
    if (state is GetSectorComplaintDetailsSuccess) {
      _isError = false;
      setState(() {
        _isLoading = false;
        complaintModel = state.response;
        resolutionStatus = complaintModel?.resolution?.status ?? 'pending';
        isResolved = complaintModel!.status != 'Pending';
        complaintId = complaintModel!.complaintId!;
        complaintDate = complaintModel!.createdAt!;
      });
    }
    if (state is GetSectorComplaintDetailsFailure) {
      _isError = true;
      errorMessage = state.message;
      complaintModel = null;
      _isLoading = false;
      statusCode = state.status;
      _showErrorSnackBar(state.message);
    }

    if (state is SectorReopenCompliantLoading) {
      _isError = false;
      setState(() {
        _isProcessing = true;
      });
    }
    if (state is SectorReopenCompliantSuccess) {
      _isError = false;
      setState(() {
        _isProcessing = false;
        complaintModel = state.response;
        isResolved = complaintModel!.status != 'Pending';
      });
    }
    if (state is SectorReopenCompliantFailure) {
      _isError = true;
      errorMessage = state.message;
      setState(() {
        complaintModel = null;
        _isProcessing = false;
        statusCode = state.status;
      });
      _showErrorSnackBar(state.message);
    }
  }

  void _showErrorSnackBar(String message) {
    CustomSnackBar.show(context: context, message: message, type: SnackBarType.error);
  }

  Widget _buildBottomSection() {
    if (complaintModel?.status == "Resolved") {
      return ReopenButton(
        onReopen: _handleReopenComplaint,
        isProcessing: _isProcessing,
        width: 160.0,
      );
    }else if (complaintModel?.resolution?.status == "under_review") {
      return ActionButtonsWidget(
        onResolved: _handleResolved,
        onRejected: _handleRejected,
        isRejectLoading: _isRejectLoading,
        isResolvedLoading: _isResolvedLoading,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void _handleResolved() async {
    context.read<SectorAdminHomeBloc>().add(SectorApproveResolution(id: complaintModel?.resolution?.id ?? ''));
  }

  void _handleRejected(String reason) async {
    context.read<SectorAdminHomeBloc>().add(SectorRejectResolution(rejectedNote: reason, resolutionId: complaintModel?.resolution?.id ?? ''));
  }

  Future<void> _handleReopenComplaint() async {
    final confirmed = await _showConfirmationDialog();
    if (confirmed != true) return;
    // Simulate API call
    context.read<SectorAdminHomeBloc>().add(SectorReopenCompliant(complaintId: complaintModel?.id ?? ''));
  }

  Future<bool?> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text(
            'Confirm Action',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20.0,
            ),
          ),
          content: Text(
            'Are you sure you want to reopen this complaint?',
            style: const TextStyle(fontSize: 16.0),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                disabledBackgroundColor: Colors.amber[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Reopen',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}