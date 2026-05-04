import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences prefs;

  AuthRepositoryImpl({required this.remoteDataSource, required this.prefs});

  @override
  Future<Either<Failure, UserEntity>> login(String mobileNo, String password) async {
    try {
      final result = await remoteDataSource.login(mobileNo, password);
      final user = UserEntity(
        id: result['user']['id'],
        name: result['user']['name'],
        email: result['user']['email'] ?? '',
        mobileNo: result['user']['mobileNo'],
      );
      
      await prefs.setString('access_token', result['accessToken']);
      await prefs.setString('refresh_token', result['refreshToken']);
      
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(_handleError(e)));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(Map<String, dynamic> data) async {
    try {
      final user = await remoteDataSource.register(data);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(_handleError(e)));
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp(String mobileNo, String type) async {
    try {
      await remoteDataSource.sendOtp(mobileNo, type);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(_handleError(e)));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(String mobileNo, String code, String type) async {
    try {
      final success = await remoteDataSource.verifyOtp(mobileNo, code, type);
      return Right(success);
    } catch (e) {
      return Left(ServerFailure(_handleError(e)));
    }
  }

  String _handleError(dynamic e) {
    if (e is DioException) {
      if (e.response != null && e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          // Check for validation errors array
          if (data['errors'] != null && data['errors'] is List && data['errors'].isNotEmpty) {
            return data['errors'][0]['message'] ?? 'Validation error';
          }
          // Check for general message
          if (data['message'] != null) {
            return data['message'];
          }
        }
      }
      return e.message ?? 'Network error occurred';
    }
    if (e is Exception) return e.toString().replaceAll('Exception: ', '');
    return 'An unexpected error occurred';
  }
}
