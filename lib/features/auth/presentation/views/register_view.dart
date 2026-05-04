import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../pages/otp_page.dart';

class RegisterView extends StatefulWidget {
  final VoidCallback? onRegisterComplete;
  const RegisterView({super.key, this.onRegisterComplete});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _ownerNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _gstController = TextEditingController();
  final _licenseController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleRegisterClick() {
    if (_formKey.currentState?.validate() ?? false) {
      // Step 1: Send OTP for registration
      context.read<AuthBloc>().add(
            SendOtpRequested(_mobileController.text, 'REGISTRATION'),
          );
    }
  }

  void _completeRegistration() {
    final data = {
      'name': _ownerNameController.text.trim(),
      'mobileNo': _mobileController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
      'gstNumber': _gstController.text.trim().isEmpty ? null : _gstController.text.trim(),
      'licenseNumber': _licenseController.text.trim(),
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _ownerNameController, 
                label: 'Owner Name', 
                icon: Icons.person_outline,
                validator: (val) => (val == null || val.length < 2) ? 'Name must be at least 2 characters' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _mobileController, 
                label: 'Mobile Number', 
                icon: Icons.phone_android_outlined, 
                keyboardType: TextInputType.phone,
                validator: (val) => (val == null || !RegExp(r'^[6-9]\d{9}$').hasMatch(val)) ? 'Invalid Indian mobile number' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController, 
                label: 'Email', 
                icon: Icons.email_outlined, 
                keyboardType: TextInputType.emailAddress,
                validator: (val) => (val == null || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) ? 'Invalid email address' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController, 
                label: 'Password', 
                icon: Icons.lock_outline, 
                isPassword: true,
                validator: (val) {
                  if (val == null || val.length < 8) return 'Password must be at least 8 characters';
                  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])').hasMatch(val)) {
                    return 'Must contain uppercase, lowercase, number, and special character';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _gstController, 
                label: 'GST Number (Optional)', 
                icon: Icons.business_outlined,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return null;
                  if (!RegExp(r'^\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1}$').hasMatch(val)) {
                    return 'Invalid GST number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _licenseController, 
                label: 'License Number', 
                icon: Icons.assignment_outlined,
                validator: (val) => (val == null || val.length < 3) ? 'License number is required' : null,
              ),
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
