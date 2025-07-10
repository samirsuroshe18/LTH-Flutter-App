import 'package:complaint_portal/features/super_admin_home/widgets/resolution_details_dialog.dart';
import 'package:complaint_portal/features/technician_home/models/technician_complaint_model.dart';
import 'package:flutter/material.dart';

class AssignComplaintCard extends StatelessWidget {
  final AssignComplaint data;
  final VoidCallback? onStartWork;
  final VoidCallback? onSubmit;
  final VoidCallback? onViewResolution;
  final bool isStartLoading;

  const AssignComplaintCard({super.key, required this.data, this.onStartWork, this.onSubmit, this.onViewResolution, this.isStartLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      data.description ?? "NA",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3B4E),
                      ),
                    ),
                  ),
                  StatusChip(status: data.resolution?.status ?? 'pending'),
                ],
              ),
              SizedBox(height: 8),

              // Query ID
              Text(
                'ID: ${data.complaintId ?? "NA"}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12),

              // Location
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data.location ?? "NA",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Sector
              Row(
                children: [
                  Icon(Icons.category, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    data.sector ?? "NA",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Assigned Time
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    data.assignedAt!=null?
                    _formatTime(data.assignedAt!)
                    : "NA",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Assigned By
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    'Assigned by: ${data.assignedBy?.userName ?? "NA"}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),

              if (data.resolution?.status == 'rejected' && data.resolution?.rejectedNote != null) ...[
                SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.report_problem, size: 18, color: Colors.red[400]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Rejection Reason: ${data.resolution?.rejectedNote}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              if (data.status != 'Resolved') ...[
                SizedBox(height: 16),
                _buildActionButtons(context, data.resolution?.status ?? 'pending'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String status) {
    return Row(
      children: [
        if (status == 'pending')
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isStartLoading ? null : onStartWork,
              icon: isStartLoading
                  ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Icon(Icons.play_arrow, size: 18),
              label: Text(
                isStartLoading ? 'Starting...' : 'Start Work',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),

        if (status == 'in_progress' || status == 'rejected')
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onSubmit,
            icon: Icon(Icons.check_circle, size: 18),
            label: Text(
              'Submit Resolution',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ),

        if (status == 'under_review')
        Expanded(
          child: ElevatedButton.icon(
            onPressed: ()=> _showResolutionDialog(context),
            icon: Icon(Icons.check_circle, size: 18),
            label: Text(
              'View Resolution',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ),

        if(data.status == 'Resolved')
          Expanded(
            child: ElevatedButton.icon(
              onPressed: ()=> _showResolutionDialog(context),
              icon: Icon(Icons.check_circle, size: 18),
              label: Text('View Resolution'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showResolutionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ResolutionDetailsDialog(
        imageUrl: data.resolution?.resolutionAttachment ?? '',
        resolutionNote: data.resolution?.resolutionNote ?? '',
        timestamp: data.resolution?.resolutionSubmittedAt,
        isNetworkImage: true,
        submitedOn: 'Submited At',
      ),
    );
  }
}


String _formatTime(DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);

  if (difference.inDays > 0) {
    return '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m ago';
  } else {
    return 'Just now';
  }
}

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case 'pending':
        backgroundColor = Colors.amber.withValues(alpha: 0.2);
        textColor = Colors.amber;
        text = 'Pending';
        icon = Icons.pending;
        break;
      case 'under_review':
        backgroundColor = Colors.blue.withValues(alpha: 0.2);
        textColor = Colors.blue;
        text = 'Under Review';
        icon = Icons.work;
        break;
      case 'in_progress':
        backgroundColor = Colors.orange.withValues(alpha: 0.2);
        textColor = Colors.orange;
        text = 'In Progress';
        icon = Icons.build_circle;
        break;
      case 'approved':
        backgroundColor = Colors.green.withValues(alpha: 0.2);
        textColor = Colors.green;
        text = 'Resolved';
        icon = Icons.check_circle;
        break;
      case 'rejected':
        backgroundColor = Colors.red.withValues(alpha: 0.2);
        textColor = Colors.red;
        text = 'Rejected';
        icon = Icons.cancel;
        break;
      default:
        backgroundColor = Colors.grey.withValues(alpha: 0.2);
        textColor = Colors.grey;
        text = 'Unknown';
        icon = Icons.help_outline;
    }

    return Chip(
      avatar: Icon(icon, size: 16, color: textColor),
      label: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      shape: StadiumBorder(
        side: BorderSide(color: textColor.withValues(alpha: 0.5)),
      ),
    );
  }
}

