import 'package:complaint_portal/common_widgets/custom_cached_network_image.dart';
import 'package:complaint_portal/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:complaint_portal/features/super_admin_home/models/sector_admin_model.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class SectorAdminCard extends StatelessWidget {
  final Sectoradmin data;
  final VoidCallback showDeleteConfirmation;
  const SectorAdminCard({super.key, required this.data, required this.showDeleteConfirmation});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.2),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Profile Image Section
                CustomCachedNetworkImage(
                  isCircular: true,
                  size: 64,
                  imageUrl: null,
                  errorImage: Icons.person,
                  borderWidth: 3,
                  onTap: ()=> CustomFullScreenImageViewer.show(context, null),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            data.userName ?? "NA",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Active',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.role ?? "NA",
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.call, size: 16, color: Colors.green),
                            ),
                            const WidgetSpan(child: SizedBox(width: 4)),
                            TextSpan(
                              text: data.phoneNo ?? "NA",
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 16, color: Colors.blueGrey),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              data.email ?? "NA",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: showDeleteConfirmation,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text('Delete Account'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final message = 'Here are the credentials:\nEmail: ${data.email ?? "NA"}\nPassword: ${data.userName ?? "NA"}';
                      SharePlus.instance.share(
                        ShareParams(
                            text: message,
                            subject: 'Login Credentials'
                        ),
                      );
                    },
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('Share Creds'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}