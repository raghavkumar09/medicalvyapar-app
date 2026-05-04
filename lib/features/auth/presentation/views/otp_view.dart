import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpView extends StatefulWidget {
  final String mobileNo;
  final String type;

  const OtpView({super.key, required this.mobileNo, required this.type});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Verify Phone',
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 16),
              children: [
                const TextSpan(text: 'Enter the 6-digit code sent to '),
                TextSpan(
                  text: widget.mobileNo,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          PinCodeTextField(
            appContext: context,
            length: 6,
            controller: _otpController,
            keyboardType: TextInputType.number,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(12),
              fieldHeight: 50,
              fieldWidth: 45,
              activeFillColor: Colors.white,
              inactiveFillColor: Colors.white,
              selectedFillColor: Colors.white,
              activeColor: AppColors.primary,
              inactiveColor: Colors.grey[300],
              selectedColor: AppColors.secondary,
            ),
            cursorColor: AppColors.primary,
            enableActiveFill: true,
            onChanged: (value) {},
            onCompleted: (value) {
              final state = context.read<AuthBloc>().state;
              if (state is! AuthLoading) {
                context.read<AuthBloc>().add(
                      VerifyOtpRequested(
                        target: widget.mobileNo,
                        code: value,
                        type: widget.type,
                      ),
                    );
              }
            },
          ),
          const SizedBox(height: 32),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          if (_otpController.text.length == 6) {
                            context.read<AuthBloc>().add(
                                  VerifyOtpRequested(
                                    target: widget.mobileNo,
                                    code: _otpController.text,
                                    type: widget.type,
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
                      : const Text('VERIFY & CONTINUE'),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      SendOtpRequested(widget.mobileNo, widget.type),
                    );
              },
              child: Text(
                'Resend Code',
                style: GoogleFonts.outfit(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
