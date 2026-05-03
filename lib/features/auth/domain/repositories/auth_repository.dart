import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String identifier, String password);
  Future<Either<Failure, UserEntity>> register(Map<String, dynamic> data);
  Future<Either<Failure, void>> sendOtp(String target, String type);
  Future<Either<Failure, bool>> verifyOtp(String target, String code, String type);
}
