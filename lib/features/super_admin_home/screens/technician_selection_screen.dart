import 'package:complaint_portal/common_widgets/build_error_state.dart';
import 'package:complaint_portal/common_widgets/custom_loader.dart';
import 'package:complaint_portal/common_widgets/data_not_found_widget.dart';
import 'package:complaint_portal/common_widgets/staggered_list_animation.dart';
import 'package:complaint_portal/features/sector_admin_home/models/technician_model.dart';
import 'package:complaint_portal/features/super_admin_home/bloc/super_admin_home_bloc.dart';
import 'package:complaint_portal/features/super_admin_home/models/admin_complaint_model.dart';
import 'package:complaint_portal/features/super_admin_home/widgets/selection_technician_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TechnicianSelectionScreen extends StatefulWidget {
  final AdminComplaint complaint;

  const TechnicianSelectionScreen({super.key, required this.complaint});

  @override
  State<TechnicianSelectionScreen> createState() => _TechnicianSelectionScreenState();
}

class _TechnicianSelectionScreenState extends State<TechnicianSelectionScreen> {
  List<Technician> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    super.initState();
    context.read<SuperAdminHomeBloc>().add(GetSelectionTechnician(technicianType: widget.complaint.sector!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'Select Technicians',
        ),
      ),
      body: BlocConsumer<SuperAdminHomeBloc, SuperAdminHomeState>(
        listener: (context, state) {
          if (state is GetSelectionTechnicianLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is GetSelectionTechnicianSuccess) {
            data.clear();
            data.addAll(state.response);
            _isLoading = false;
            _isError = false;
          }
          if (state is GetSelectionTechnicianFailure) {
            data = [];
            _isLoading = false;
            _isError = true;
            statusCode= state.status;
          }
        },
        builder: (context, state) {
          if (data.isNotEmpty && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: AnimationLimiter(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: data.length,
                  padding: EdgeInsets.only(top: 4),
                  itemBuilder: (context, index) {
                    return StaggeredListAnimation(index: index, child: SelectionTechnicianCard(data: data[index]));
                  },
                ),
              ),
            );
          } else if (_isLoading) {
            return CustomLoader();
          } else if (data.isEmpty && _isError == true && statusCode == 401) {
            return BuildErrorState(onRefresh: _onRefresh);
          } else {
            return DataNotFoundWidget(
              onRefresh: _onRefresh,
              title: "No Technical Staff Found",
              subtitle: "Your technical team roster is empty. Add technical staff members to manage assignments and track their progress.",
              buttonText: "Refresh Staff",
              customIcon: Icons.engineering_outlined,
              primaryColor: Colors.blue,
              animationSize: 180,
            );
          }
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    context.read<SuperAdminHomeBloc>().add(GetSelectionTechnician(technicianType: widget.complaint.sector!));
  }
}