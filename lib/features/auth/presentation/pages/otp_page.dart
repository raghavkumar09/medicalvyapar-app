import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../views/otp_view.dart';

class OtpPage extends StatelessWidget {
  final String mobileNo;
  final String type;
  final VoidCallback onVerified;

  const OtpPage({
    super.key,
    required this.mobileNo,
    required this.type,
    required this.onVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.secondary,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerifiedSuccess) {
            onVerified();
          } else if (state is AuthError) {
            if (ModalRoute.of(context)?.isCurrent == true) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
            }
          } else if (state is OtpSentSuccess) {
             if (ModalRoute.of(context)?.isCurrent == true) {
               ScaffoldMessenger.of(context)
                 ..hideCurrentSnackBar()
                 ..showSnackBar(
                   const SnackBar(content: Text('OTP sent again!'), backgroundColor: AppColors.primary),
                 );
             }
          }
        },
        child: OtpView(mobileNo: mobileNo, type: type),
      ),
    );
  }
}
