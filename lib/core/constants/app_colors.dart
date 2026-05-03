import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF66BB6A); // Green from logo cross
  static const Color secondary = Color(0xFF1565C0); // Blue from logo hands
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFD32F2F);
  
  static const LinearGradient logoGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
