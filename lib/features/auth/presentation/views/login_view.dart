import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final VoidCallback onRegisterTap;

  const LoginView({
    super.key,
    required this.formKey,
    required this.identifierController,
    required this.passwordController,
    required this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Center(
            child: Image.asset('assets/images/logo.png', height: 100),
          ),
          const SizedBox(height: 40),
          Text(
            'Welcome Back!',
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 40),
          Form(
            key: formKey,
            child: Column(
              children: [
                _buildField(
                  controller: identifierController,
                  label: 'Mobile Number or Email',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                _buildField(
                  controller: passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 32),
                _buildLoginButton(context),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      validator: (value) => value!.isEmpty ? 'Field required' : null,
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: state is AuthLoading
                ? null
                : () {
                    if (formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                            LoginRequested(
                              identifierController.text,
                              passwordController.text,
                            ),
                          );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
            ),
            child: state is AuthLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text('LOG IN', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? ", style: GoogleFonts.outfit(color: Colors.grey[600])),
        GestureDetector(
          onTap: onRegisterTap,
          child: Text(
            'Register Now',
            style: GoogleFonts.outfit(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
