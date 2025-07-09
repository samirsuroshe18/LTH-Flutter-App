import 'package:flutter/material.dart';

// Enum for complaint status
enum ComplaintStatus {
  pending,
  inProgress,
  resolved,
  rejected,
}

// Data model for complaint
class Complaint {
  final String id;
  final String locationName;
  final String sectorName;
  final DateTime createdAt;
  final ComplaintStatus status;
  final String? description;

  Complaint({
    required this.id,
    required this.locationName,
    required this.sectorName,
    required this.createdAt,
    required this.status,
    this.description,
  });
}

// Main complaint card widget
class ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  final VoidCallback? onTap;

  const ComplaintCard({
    Key? key,
    required this.complaint,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap ?? () => _navigateToDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with status and complaint ID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(complaint.status),
                  _buildComplaintId(complaint.id),
                ],
              ),

              const SizedBox(height: 12),

              // Location row
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      complaint.locationName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Sector row
              Row(
                children: [
                  Icon(
                    Icons.build_outlined,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      complaint.sectorName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Created at row
              Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDateTime(complaint.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ComplaintStatus status) {
    Color chipColor;
    Color textColor;
    String label;
    IconData icon;

    switch (status) {
      case ComplaintStatus.resolved:
        chipColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        label = 'Resolved';
        icon = Icons.check_circle_outline;
        break;
      case ComplaintStatus.pending:
        chipColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        label = 'Pending';
        icon = Icons.access_time_outlined;
        break;
      case ComplaintStatus.inProgress:
        chipColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        label = 'In Progress';
        icon = Icons.sync_outlined;
        break;
      case ComplaintStatus.rejected:
        chipColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        label = 'Rejected';
        icon = Icons.cancel_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintId(String id) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.confirmation_number_outlined,
          size: 14,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 4),
        Text(
          '#$id',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    final day = dateTime.day;
    final month = months[dateTime.month - 1];
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$day $month, $displayHour:$minute $period';
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.pushNamed(context, '/complaint-details-screen');
  }
}