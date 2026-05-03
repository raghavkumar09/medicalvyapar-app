import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'core/constants/app_colors.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'core/config/environment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Environment based on dart-define flag
  const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  if (env == 'prod') {
    await Environment.init(EnvironmentType.prod);
  } else {
    await Environment.init(EnvironmentType.dev);
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
