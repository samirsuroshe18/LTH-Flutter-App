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
          CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.success);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Submit Resolution"),
            centerTitle: true,
            backgroundColor: Colors.green[600],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Preview
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: _selectedImage == null
                        ? Center(child: Text("No image selected", style: TextStyle(color: Colors.grey[600])))
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Add & Remove Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: ()=> DocumentPickerUtils.showDocumentPickerSheet(context: context, onPickImage: _pickImage, isOnlyImage: true, onPickPDF: null),
                        icon: Icon(Icons.add_a_photo),
                        label: Text("Add Image"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _selectedImage == null ? null : _removeImage,
                        icon: Icon(Icons.delete),
                        label: Text("Remove Image"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Resolution Note Field
                  TextField(
                    controller: _noteController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Resolution Note",
                      hintText: "Enter details about the resolution...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : () => _onSubmit(context),
                    icon: isLoading
                        ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Icon(Icons.check_circle),
                    label: Text(
                      isLoading ? "Submitting..." : "Submit Resolution",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}