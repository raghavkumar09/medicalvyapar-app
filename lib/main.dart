import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'core/constants/app_colors.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'core/config/environment.dart';

import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Handle errors that are not caught by Flutter
  PlatformDispatcher.instance.onError = (error, stack) {
    if (error.toString().contains('Failed to load font')) {
      debugPrint('Font loading failed: $error. Falling back to default font.');
      return true; // Handle the error
    }
    return false;
  };

  // Automatically detect environment from flavor
  // Running with: flutter run --flavor dev
  final String? flavor = appFlavor;
  final EnvironmentType envType = (flavor == 'prod') ? EnvironmentType.prod : EnvironmentType.dev;

  // Initialize Environment
  await Environment.init(envType);

  if (kDebugMode) {
    print('🚀 Running in DEBUG mode with ${Environment.current.name.toUpperCase()} environment (Flavor: $flavor)');
  } else {
    print('📦 Running in RELEASE mode with ${Environment.current.name.toUpperCase()} environment (Flavor: $flavor)');
  }

  // Initialize Dependency Injection
  await di.init();
  
  runApp(const MedicalVyaparApp());
}

class MedicalVyaparApp extends StatelessWidget {
  const MedicalVyaparApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
      ],
      child: MaterialApp(
        title: 'MediVyapar',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.background,
          ),
          textTheme: GoogleFonts.outfitTextTheme(),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
