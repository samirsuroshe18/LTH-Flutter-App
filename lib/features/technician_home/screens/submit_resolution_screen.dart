import 'dart:io';

import 'package:complaint_portal/common_widgets/custom_snackbar.dart';
import 'package:complaint_portal/features/technician_home/bloc/technician_home_bloc.dart';
import 'package:complaint_portal/features/technician_home/models/technician_complaint_model.dart';
import 'package:complaint_portal/utils/document_picker_utils.dart';
import 'package:complaint_portal/utils/media_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class SubmitResolutionScreen extends StatefulWidget {
  final AssignComplaint data;
  const SubmitResolutionScreen({super.key, required this.data});

  @override
  State<SubmitResolutionScreen> createState() => _SubmitResolutionScreenState();
}

class _SubmitResolutionScreenState extends State<SubmitResolutionScreen> {
  File? _selectedImage;
  final TextEditingController _noteController = TextEditingController();
  String? tenantAgreementType;
  bool isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final File? image = await MediaPickerHelper.pickImageFile(context: context, source: source);

      if (image != null) {
        final String fileExtension = path.extension(image.path).toLowerCase();

        setState(() {
          _selectedImage = image;
          tenantAgreementType = fileExtension;
        });
      }
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Error picking image: $e',
        type: SnackBarType.error,
      );
    }
  }

  void _removeImage() {
    setState(() => _selectedImage = null);
  }

  void _onSubmit(BuildContext context) {
    final note = _noteController.text.trim();

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select an image.")));
      return;
    }

    if (note.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a resolution note.")));
      return;
    }

    context.read<TechnicianHomeBloc>().add(AddComplaintResolution(
      complaintId: widget.data.id!,
      resolutionNote: note,
      file: _selectedImage!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TechnicianHomeBloc, TechnicianHomeState>(
      listener: (context, state) {
        if(state is AddComplaintResolutionLoading){
          isLoading = true;
        }
        if (state is AddComplaintResolutionSuccess) {
          isLoading = false;
          CustomSnackBar.show(context: context, message: "Resolution submitted successfully!", type: SnackBarType.success);
          _noteController.clear();
          setState(() => _selectedImage = null);
          Navigator.of(context).pop(state.response);
        }
        if (state is AddComplaintResolutionFailure) {
          isLoading = false;
          CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.success);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Submit Resolution",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          backgroundColor: Colors.grey[50],
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Section Header
                  Text(
                    "Resolution Image",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Enhanced Image Preview Container
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: _selectedImage == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "No image selected",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Please add an image to show resolution",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Enhanced Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: ()=> DocumentPickerUtils.showDocumentPickerSheet(
                              context: context,
                              onPickImage: _pickImage,
                              isOnlyImage: true,
                              onPickPDF: null
                          ),
                          icon: Icon(Icons.add_photo_alternate_outlined, size: 20),
                          label: Text(
                            "Add Image",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _selectedImage == null ? null : _removeImage,
                          icon: Icon(Icons.delete_outline, size: 20),
                          label: Text(
                            "Remove",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedImage == null ? Colors.grey[400] : Colors.red[500],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: _selectedImage == null ? 0 : 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Resolution Note Section Header
                  Text(
                    "Resolution Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Enhanced TextField for Resolution Note
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _noteController,
                      maxLines: 6,
                      minLines: 6,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey[800],
                      ),
                      decoration: InputDecoration(
                        labelText: "Resolution Note",
                        hintText: "Enter detailed information about the resolution...\n\n• What was the issue?\n• How was it resolved?\n• Any follow-up needed?",
                        labelStyle: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w600,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.all(20),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Enhanced Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : () => _onSubmit(context),
                      icon: isLoading
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : Icon(Icons.check_circle_outline, size: 22),
                      label: Text(
                        isLoading ? "Submitting Resolution..." : "Submit Resolution",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLoading ? Colors.grey[400] : Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: isLoading ? 0 : 4,
                        shadowColor: Colors.green.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}