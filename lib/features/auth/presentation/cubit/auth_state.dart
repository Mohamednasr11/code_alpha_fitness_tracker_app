part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final AppUser user;
  AuthSuccessState(this.user);
}

class AuthUnauthenticatedState extends AuthState {}
class AuthRegistrationSuccessState  extends AuthState {}

class AuthFailureState extends AuthState {
  final AuthFailure failure;
  AuthFailureState(this.failure);
}