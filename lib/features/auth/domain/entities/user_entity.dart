import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String mobileNo;
  final String? gstNumber;
  final String? licenseNumber;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNo,
    this.gstNumber,
    this.licenseNumber,
  });

  @override
  List<Object?> get props => [id, name, email, mobileNo, gstNumber, licenseNumber];
}
