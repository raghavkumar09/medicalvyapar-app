import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.mobileNo,
    super.gstNumber,
    super.licenseNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'] ?? '',
      mobileNo: json['mobileNo'],
      gstNumber: json['gstNumber'],
      licenseNumber: json['licenseNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobileNo': mobileNo,
      'gstNumber': gstNumber,
      'licenseNumber': licenseNumber,
    };
  }
}
