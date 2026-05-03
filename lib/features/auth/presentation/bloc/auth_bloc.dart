import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await authRepository.login(event.identifier, event.password);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(AuthAuthenticated(user)),
      );
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await authRepository.register(event.data);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(AuthAuthenticated(user)),
      );
    });

    on<SendOtpRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await authRepository.sendOtp(event.target, event.type);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) => emit(OtpSentSuccess()),
      );
    });

    on<VerifyOtpRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await authRepository.verifyOtp(event.target, event.code, event.type);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (success) {
          if (success) {
            emit(OtpVerifiedSuccess());
          } else {
            emit(const AuthError("OTP Verification Failed"));
          }
        },
      );
    });
  }
}
