import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String identifier;
  final String password;

  const LoginRequested(this.identifier, this.password);

  @override
  List<Object?> get props => [identifier, password];
}

class RegisterRequested extends AuthEvent {
  final Map<String, dynamic> data;

  const RegisterRequested(this.data);

  @override
  List<Object?> get props => [data];
}

class SendOtpRequested extends AuthEvent {
  final String target;
  final String type;

  const SendOtpRequested(this.target, this.type);

  @override
  List<Object?> get props => [target, type];
}

class VerifyOtpRequested extends AuthEvent {
  final String target;
  final String code;
  final String type;

  const VerifyOtpRequested({
    required this.target,
    required this.code,
    required this.type,
  });

  @override
  List<Object?> get props => [target, code, type];
}
