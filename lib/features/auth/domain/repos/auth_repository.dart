import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/features/auth/domain/entities/app_user.dart';

import '../../../../core/utils/auth_failure.dart';

abstract class AuthRepository {
  AppUser?get currentUser;
  Stream<AppUser?>get authStateChanges;
  Future<Either<AuthFailure, AppUser>> signInWithEmail(String email, String password);
  Future<Either<AuthFailure, AppUser>> registerWithEmail(String email, String password);
  Future<Either<AuthFailure, AppUser>> signInWithGoogle();
  Future<Either<AuthFailure, void>> signOut();}