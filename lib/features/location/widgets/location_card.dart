import 'dart:convert';
import 'dart:typed_data';

import 'package:complaint_portal/features/location/models/location_model.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final Location location;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDownloadPDF;

  const LocationCard({
    super.key,
    required this.location,
    required this.onEdit,
    required this.onDelete,
    required this.onDownloadPDF,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 400;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: 2,
          color: Colors.white,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row - Name and ID Badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        location.name ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        'ID: ${location.locationId}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Main Content Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // QR Code
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () => _showQrCodeDialog(context, location.qrCode),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: location.qrCode != null &&
                                location.qrCode!.startsWith('data:image')
                                ? Image.memory(
                              _decodeBase64Image(location.qrCode!),
                              fit: BoxFit.cover,
                            )
                                : Container(
                              color: Colors.grey.shade50,
                              child: Icon(
                                Icons.qr_code,
                                size: 28,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Date Info - Takes remaining space
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.schedule, size: 12, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Created: ${_formatDate(location.createdAt!)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(Icons.update, size: 12, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Updated: ${_formatDate(location.updatedAt!)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
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

                const SizedBox(height: 12),

                // Action Buttons - Responsive Layout
                if (isMobile)
                // Mobile: Stack buttons vertically
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              onPressed: onEdit,
                              icon: Icons.edit_outlined,
                              label: 'Edit',
                              isOutlined: true,
                              context: context,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildActionButton(
                              onPressed: onDownloadPDF,
                              icon: Icons.download_outlined,
                              label: 'PDF',
                              isOutlined: false,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: _buildActionButton(
                          onPressed: onDelete,
                          icon: Icons.delete_outline,
                          label: 'Delete',
                          isOutlined: true,
                          isDelete: true,
                          context: context,
                        ),
                      ),
                    ],
                  )
                else
                // Tablet/Desktop: Horizontal row
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          onPressed: onEdit,
                          icon: Icons.edit_outlined,
                          label: 'Edit',
                          isOutlined: true,
                          context: context,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          onPressed: onDownloadPDF,
                          icon: Icons.download_outlined,
                          label: 'PDF',
                          isOutlined: false,
                          context: context,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          onPressed: onDelete,
                          icon: Icons.delete_outline,
                          label: 'Delete',
                          isOutlined: true,
                          isDelete: true,
                          context: context,
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
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isOutlined,
    required BuildContext context,
    bool isDelete = false,
  }) {
    final color = isDelete ? Colors.red.shade600 : Theme.of(context).primaryColor;

    return SizedBox(
      height: 32,
      child: isOutlined
          ? OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 14),
        label: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      )
          : ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 14),
        label: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Uint8List _decodeBase64Image(String base64String) {
    final base64Data = base64String.split(',').last;
    return base64Decode(base64Data);
  }

  void _showQrCodeDialog(BuildContext context, String? qrCode) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.all(20),
        content: Container(
          constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
          child: qrCode != null && qrCode.startsWith('data:image')
              ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              _decodeBase64Image(qrCode),
              fit: BoxFit.contain,
            ),
          )
              : Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
                Text(
                  'QR Code not available',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Close',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}