import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/features/auth/data/datasource/firebase_auth_datasource.dart';
import 'package:fitness_tracker/features/auth/domain/entities/app_user.dart';
import 'package:fitness_tracker/features/auth/domain/repos/auth_repository.dart';

import '../../../../core/utils/auth_failure.dart';

class AuthRepoImpl extends AuthRepository {
  final FirebaseAuthDataSource _authDataSource;

  AuthRepoImpl(this._authDataSource);

  // ─── Mapper: Firebase User → AppUser ──────────────────

  AppUser _toAppUser(User user) => AppUser(
    id: user.uid,
    email: user.email ?? '',
    displayName: user.displayName,
    photoUrl: user.photoURL,
  );

  // ─── Mapper: FirebaseAuthException → AuthFailure ──────

  AuthFailure _mapFirebaseError(FirebaseAuthException e) {
    return switch (e.code) {
      'user-not-found'        => const UserNotFound(),
      'wrong-password'        => const InvalidCredentials('كلمة المرور غلط'),
      'invalid-credential'    => const InvalidCredentials('البيانات غلط'),
      'email-already-in-use'  => const EmailAlreadyInUse(),
      'weak-password'         => const WeakPassword(),
      'invalid-email'         => const InvalidCredentials('الإيميل مش صحيح'),
      'network-request-failed'=> const NetworkError(),
      'too-many-requests'     => const TooManyRequests(),
      _                       => UnknownError(e.message ?? 'Unknown error'),
    };
  }

  // ─── Sign In with Email ────────────────────────────────

  @override
  Future<Either<AuthFailure, AppUser>> signInWithEmail(
      String email,
      String password,
      ) async {
    try {
      final result = await _authDataSource.signInWithEmail(email, password);
      return Right(_toAppUser(result.user!));
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (e) {
      return Left(UnknownError(e.toString()));
    }
  }

  // ─── Register with Email ───────────────────────────────

  @override
  Future<Either<AuthFailure, AppUser>> registerWithEmail(
      String email,
      String password,
      ) async {
    try {
      final result = await _authDataSource.registerWithEmail(email, password);
      return Right(_toAppUser(result.user!));
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (e) {
      return Left(UnknownError(e.toString()));
    }
  }

  // ─── Sign In with Google ───────────────────────────────

  @override
  Future<Either<AuthFailure, AppUser>> signInWithGoogle() async {
    try {
      final result = await _authDataSource.signInWithGoogle();

      if (result == null) return const Left(GoogleSignInCancelled());

      return Right(_toAppUser(result.user!));
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (e) {
      return Left(UnknownError(e.toString()));
    }
  }

  // ─── Sign Out ──────────────────────────────────────────

  @override
  Future<Either<AuthFailure, void>> signOut() async {
    try {
      await _authDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(UnknownError(e.toString()));
    }
  }

  // ─── Current User ──────────────────────────────────────

  @override
  AppUser? get currentUser {
    final user = _authDataSource.currentUser;
    return user != null ? _toAppUser(user) : null;
  }

  // ─── Auth State Stream ─────────────────────────────────

  @override
  Stream<AppUser?> get authStateChanges =>
      _authDataSource.authStateChanges.map(
            (user) => user != null ? _toAppUser(user) : null,
      );
}