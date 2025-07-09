import 'package:complaint_portal/features/super_admin_home/models/ActiveSectorMode.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SectorCard extends StatelessWidget {
  final ActiveSectorModel data;

  const SectorCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final adminText = data.admins?.map((a) => "${a.name} (${a.email})").join('\n');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.sectorName ?? "NA", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Sector Admin(s):\n$adminText"),
            SizedBox(height: 4),
            Text("Complaints: ${data.pendingCount} / ${data.totalCount}"),
            SizedBox(height: 4),
            Text("Last Updated: ${data.lastUpdated != null ? DateFormat('dd MMM yyyy, hh:mm a').format(data.lastUpdated!) : 'N/A'}"),
          ],
        ),
      ),
    );
  }
}

