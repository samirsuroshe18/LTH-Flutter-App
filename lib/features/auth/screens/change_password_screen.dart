import 'package:complaint_portal/common_widgets/custom_snackbar.dart';
import 'package:complaint_portal/features/auth/bloc/auth_bloc.dart';
import 'package:complaint_portal/features/auth/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state){
          if(state is ChangePasswordLoading){
            _isLoading = true;
          }
          if(state is ChangePasswordSuccess){
            _currentPasswordController.clear();
            _newPasswordController.clear();
            _confirmPasswordController.clear();
            _isLoading = false;
            CustomSnackBar.show(context: context, message: state.response['message'], type: SnackBarType.success);
          }
          if(state is ChangePasswordFailure){
            if(state.message == 'data and hash arguments required'){
              CustomSnackBar.show(context: context, message: 'Unable to change password. Please check your current credentials.', type: SnackBarType.error);
            }else{
              CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
            }
            _isLoading = false;
          }
        },
        builder: (context, state){
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    icon: const Icon(Icons.lock_open),
                    hintText: 'Enter current password',
                    controller: _currentPasswordController,
                    errorMsg: 'Please enter current password',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    icon: const Icon(Icons.password),
                    hintText: 'Enter new password',
                    controller: _newPasswordController,
                    errorMsg: 'Please enter new password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    icon: const Icon(Icons.password),
                    hintText: 'Enter confirm new password',
                    controller: _confirmPasswordController,
                    errorMsg: 'Please enter confirm new password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onChanged,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Border radius
                      ), // Border color and width
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                      "Change Password",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70),
                    ),
                  )
                  // SettingBtn(onPressed: _onChanged, isLoading: _isLoading, text: 'Change Password',),
                ],
              ),
            ),
          );
        },
      )
    );
  }

  void _onChanged(){
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(ChangePassword(
        oldPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),));
    }
  }
}
