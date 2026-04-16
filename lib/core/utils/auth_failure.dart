sealed class AuthFailure {
  const AuthFailure();
}

class UserNotFound extends AuthFailure {
  const UserNotFound();
}

class InvalidCredentials extends AuthFailure {
  final String message;
  const InvalidCredentials(this.message);
}

class EmailAlreadyInUse extends AuthFailure {
  const EmailAlreadyInUse();
}

class WeakPassword extends AuthFailure {
  const WeakPassword();
}

class NetworkError extends AuthFailure {
  const NetworkError();
}

class TooManyRequests extends AuthFailure {
  const TooManyRequests();
}

class GoogleSignInCancelled extends AuthFailure {
  const GoogleSignInCancelled();
}

class UnknownError extends AuthFailure {
  final String message;
  const UnknownError(this.message);
}