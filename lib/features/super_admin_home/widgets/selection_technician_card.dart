import 'package:complaint_portal/common_widgets/custom_cached_network_image.dart';
import 'package:complaint_portal/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:complaint_portal/features/sector_admin_home/models/technician_model.dart';
import 'package:flutter/material.dart';

class SelectionTechnicianCard extends StatelessWidget {
  final Technician data;
  const SelectionTechnicianCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        tileColor: Colors.grey.shade100,
        leading: CustomCachedNetworkImage(
          size: 42,
          borderWidth: 1,
          errorImage: Icons.person,
          isCircular: true,
          imageUrl: null,
          onTap: ()=> CustomFullScreenImageViewer.show(
              context,
              null,
              errorImage: Icons.person
          ),
        ),
        title: Text(
          data.userName ?? 'NA',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade900,
          ),
        ),
        subtitle: Text(
          data.technicianType ?? '',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade500),
        onTap: () => Navigator.pop(context, data),
      ),
    );
  }
}
