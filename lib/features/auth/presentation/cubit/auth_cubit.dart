import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_tracker/features/auth/domain/entities/app_user.dart';
import 'package:fitness_tracker/features/auth/domain/repos/auth_repository.dart';
import 'package:fitness_tracker/core/utils/auth_failure.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  late final StreamSubscription<AppUser?> _authStateSubscription;
  bool _isRegister = false;

  AuthCubit(this._authRepository) : super(AuthInitialState()) {
    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      if (_isRegister) return;
      if (user != null) {
        emit(AuthSuccessState(user));
      } else {
        emit(AuthUnauthenticatedState());
      }
    });
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }

  // ─── Sign In with Email ────────────────────────────────

  Future<void> signInWithEmail(String email, String password) async {
    emit(AuthLoadingState());

    final result = await _authRepository.signInWithEmail(email, password);
    result.fold(
      (failure) => emit(AuthFailureState(failure)),
      (user) => null,
    );
  }

  // ─── Register with Email ───────────────────────────────

  Future<void> registerWithEmail(String email, String password) async {
    emit(AuthLoadingState());
    _isRegister=true;

    final result = await _authRepository.registerWithEmail(email, password);

    result.fold(
      (failure) async{
        _isRegister=false;
        emit(AuthFailureState(failure));
      },
      (user) async{
        await _authRepository.signOut();
        _isRegister=false;
        emit(AuthRegistrationSuccessState());

      }
    );
  }

  // ─── Sign In with Google ───────────────────────────────

  Future<void> signInWithGoogle() async {
    emit(AuthLoadingState());

    final result = await _authRepository.signInWithGoogle();

    result.fold(
      (failure) => emit(AuthFailureState(failure)),
      (user) => null,
    );
  }

  // ─── Sign Out ──────────────────────────────────────────

  Future<void> signOut() async {
    emit(AuthLoadingState());

    final result = await _authRepository.signOut();
    result.fold(
      (failure) => emit(AuthFailureState(failure)),
      (_) => null,
    );
  }

  // ─── Current User ──────────────────────────────────────

  AppUser? get currentUser => _authRepository.currentUser;
}
