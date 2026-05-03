import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../../../core/network/api_config.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String mobileNo, String password);
  Future<UserModel> register(Map<String, dynamic> data);
  Future<void> sendOtp(String mobileNo, String type);
  Future<bool> verifyOtp(String mobileNo, String code, String type);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> login(String mobileNo, String password) async {
    final response = await dio.post(ApiConfig.login, data: {
      'mobileNo': mobileNo, // Corrected key for backend
      'password': password,
    });
    return response.data['data'];
  }

  @override
  Future<UserModel> register(Map<String, dynamic> data) async {
    // We only send fields defined in RegisterInput to avoid Zod errors
    final response = await dio.post(ApiConfig.register, data: data);
    return UserModel.fromJson(response.data['data']['user']);
  }

  @override
  Future<void> sendOtp(String mobileNo, String type) async {
    await dio.post(ApiConfig.sendOtp, data: {
      'mobileNo': mobileNo, // Corrected key
      'type': type,
    });
  }

  @override
  Future<bool> verifyOtp(String mobileNo, String code, String type) async {
    final response = await dio.post(ApiConfig.verifyOtp, data: {
      'mobileNo': mobileNo, // Corrected key
      'code': code,
      'type': type,
    });
    return response.data['success'] ?? true;
  }
}
