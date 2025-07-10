import 'package:complaint_portal/features/super_admin_home/models/AdminComplaintModel.dart';
import 'package:flutter/material.dart';

class ComplaintCard extends StatelessWidget {
  final AdminComplaint complaint;
  final VoidCallback? onTap;

  const ComplaintCard({
    super.key,
    required this.complaint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () => _navigateToDetails(context),
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.blue.withValues(alpha: 0.1),
          highlightColor: Colors.blue.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with status and ID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusChip(complaint.status ?? 'NA'),
                    _buildComplaintId(complaint.complaintId ?? 'Na'),
                  ],
                ),

                const SizedBox(height: 16),

                // Location with enhanced styling
                _buildInfoRow(
                  icon: Icons.location_on,
                  iconColor: Colors.red.shade400,
                  text: complaint.location ?? 'No location provided',
                  isTitle: true,
                ),

                const SizedBox(height: 12),

                // Sector with better visual hierarchy
                _buildInfoRow(
                  icon: Icons.business_center,
                  iconColor: Colors.blue.shade400,
                  text: complaint.sector ?? 'No sector specified',
                  isTitle: false,
                ),

                const SizedBox(height: 12),

                // DateTime with improved formatting
                _buildInfoRow(
                  icon: Icons.schedule,
                  iconColor: Colors.green.shade400,
                  text: complaint.createdAt != null
                      ? _formatDateTime(complaint.createdAt!)
                      : 'No date available',
                  isTitle: false,
                ),

                const SizedBox(height: 16),

                // Priority indicator bar
                _buildPriorityBar(),

                const SizedBox(height: 12),

                // Action hint
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Tap to view details',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.blue.shade600,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String text,
    required bool isTitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isTitle ? 16 : 14,
              fontWeight: isTitle ? FontWeight.w600 : FontWeight.w500,
              color: isTitle ? Colors.grey.shade800 : Colors.grey.shade600,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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

  Widget _buildComplaintId(String id) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.confirmation_number,
            size: 14,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 4),
          Text(
            '#$id',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBar() {
    // You can customize this based on actual priority logic
    String status = complaint.status ?? 'NA';
    Color barColor;
    double fillPercent;

    switch (status) {
      case 'Resolved':
        barColor = Colors.green;
        fillPercent = 1.0;
        break;
      case 'In Progress':
        barColor = Colors.blue;
        fillPercent = 0.6;
        break;
      case 'Pending':
        barColor = Colors.orange;
        fillPercent = 0.3;
        break;
      case 'Rejected':
        barColor = Colors.red;
        fillPercent = 0.1;
        break;
      default:
        barColor = Colors.grey;
        fillPercent = 0.0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              '${(fillPercent * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: barColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: fillPercent,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [barColor.withValues(alpha: 0.7), barColor],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final day = dateTime.day;
    final month = months[dateTime.month - 1];
    final year = dateTime.year;
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$day $month $year • $displayHour:$minute $period';
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.pushNamed(context, '/complaint-details-screen', arguments: complaint);
  }
}