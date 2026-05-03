import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'otp_page.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _ownerNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _gstController = TextEditingController();
  final _licenseController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleRegisterClick() {
    if (_mobileController.text.isEmpty) return;
    
    // Step 1: Send OTP for registration
    context.read<AuthBloc>().add(
          SendOtpRequested(_mobileController.text, 'REGISTRATION'),
        );
  }

  void _completeRegistration() {
    final data = {
      'name': _ownerNameController.text,
      'mobileNo': _mobileController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'gstNumber': _gstController.text.isEmpty ? null : _gstController.text,
      'licenseNumber': _licenseController.text,
    };
    context.read<AuthBloc>().add(RegisterRequested(data));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSentSuccess) {
          // Step 2: Navigate to OTP Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpPage(
                mobileNo: _mobileController.text,
                type: 'REGISTRATION',
                onVerified: () {
                  Navigator.pop(context); // Close OTP page
                  _completeRegistration(); // Step 3: Call final register
                },
              ),
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildTextField(controller: _ownerNameController, label: 'Owner Name', icon: Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField(controller: _mobileController, label: 'Mobile Number', icon: Icons.phone_android_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(controller: _emailController, label: 'Email', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField(controller: _passwordController, label: 'Password', icon: Icons.lock_outline, isPassword: true),
            const SizedBox(height: 16),
            _buildTextField(controller: _gstController, label: 'GST Number (Optional)', icon: Icons.business_outlined),
            const SizedBox(height: 16),
            _buildTextField(controller: _licenseController, label: 'License Number', icon: Icons.assignment_outlined),
            const SizedBox(height: 32),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state is AuthLoading ? null : _handleRegisterClick,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary, foregroundColor: Colors.white),
                    child: state is AuthLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('REGISTER & VERIFY'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
