import '../config/environment.dart';

class ApiConfig {
  static String get baseUrl => Environment().baseUrl;
  
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String sendOtp = "/auth/send-otp";
  static const String verifyOtp = "/auth/verify-otp";
  static const String profile = "/auth/me";
}
