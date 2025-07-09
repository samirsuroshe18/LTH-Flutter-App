import 'package:complaint_portal/common_widgets/custom_snackbar.dart';
import 'package:complaint_portal/features/auth/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_btn.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthForgotPassLoading) {
          _isLoading = true;
        }
        if (state is AuthForgotPassSuccess) {
          emailController.clear();
          _isLoading = false;
          CustomSnackBar.show(
            context: context,
            message: state.response['message'],
            type: SnackBarType.success,
          );
        }
        if (state is AuthForgotPassFailure) {
          CustomSnackBar.show(
            context: context,
            message: state.message,
            type: SnackBarType.error,
          );
          _isLoading = false;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF2E3B4E),
            foregroundColor: Colors.white,
            title: const Text(
              'Forgot Password',
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _text(),
                const SizedBox(height: 20),
                _form(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onForgotPassPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthForgotPassword(
            emailController.text.trim(),
          ));
    }
  }

  _text() {
    return const Text(
      'Enter your email address to reset your password.',
      style: TextStyle(fontSize: 16),
    );
  }

  _form() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomTextField(
            icon: const Icon(Icons.email),
            hintText: 'Email',
            controller: emailController,
            errorMsg: 'Please enter your email',
            obscureText: false,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onForgotPassPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Border radius
              ), // Border color and width
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Color(0xFF2E3B4E),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text(
              "Reset Password",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
