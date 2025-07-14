import 'package:complaint_portal/common_widgets/custom_cached_network_image.dart';
import 'package:complaint_portal/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:complaint_portal/features/sector_admin_home/models/technician_model.dart';
import 'package:flutter/material.dart';

class TechnicianCard extends StatelessWidget {
  final Technician data;
  final VoidCallback showDeleteConfirmation;
  final VoidCallback? onDeactivate;

  const TechnicianCard({
    super.key,
    required this.data,
    required this.showDeleteConfirmation,
    this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4, // or use `6` for slightly more depth
      shadowColor: Colors.grey.withValues(alpha: 0.2), // subtle shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced Profile Image Section
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomCachedNetworkImage(
                      isCircular: true,
                      size: 50,
                      imageUrl: null,
                      errorImage: Icons.person,
                      borderWidth: 3,
                      onTap: () => CustomFullScreenImageViewer.show(context, null),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and Status Row
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data.userName ?? "NA",
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: data.isActive! ? Colors.green.withValues(alpha: 0.1) : Colors.red[700]!.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: data.isActive! ? Colors.green.withValues(alpha: 0.3) : Colors.red[700]!.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: data.isActive! ? Colors.green[700] : Colors.red[700],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    data.isActive! ? 'Active' : 'Inactive',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: data.isActive! ? Colors.green[700] : Colors.red[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Sector Type
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            data.technicianType ?? "NA",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Contact Information
                        _buildContactInfo(
                          theme,
                          icon: Icons.phone_outlined,
                          text: data.phoneNo ?? "NA",
                          color: Colors.green[600]!,
                        ),
                        const SizedBox(height: 8),
                        _buildContactInfo(
                          theme,
                          icon: Icons.email_outlined,
                          text: data.email ?? "NA",
                          color: Colors.blueGrey[600]!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Action Buttons Section
              Row(
                children: [
                  // Delete Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: showDeleteConfirmation,
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Delete Account'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: Colors.red[600],
                        side: BorderSide(color: Colors.red[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Deactivate Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onDeactivate,
                      icon: const Icon(Icons.block, size: 18),
                      label: Text(data.isActive! ? 'Deactivate': 'Activate'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: data.isActive! ? Colors.orange[700]: Colors.green,
                        side: BorderSide(color: data.isActive! ? Colors.orange[300]! : Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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

  Widget _buildContactInfo(ThemeData theme, {
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}