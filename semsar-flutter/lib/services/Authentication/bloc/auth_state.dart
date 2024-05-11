import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateInit extends AuthState {
  const AuthStateInit();
}

class AuthStateSignUp extends AuthState {
  const AuthStateSignUp();
}

class AuthStateSignIn extends AuthState {
  const AuthStateSignIn();
}

class AuthStateLogout extends AuthState {
  const AuthStateLogout();
}

class AuthStateSignUpError extends AuthState {
  final String? errorMessage;

  const AuthStateSignUpError(this.errorMessage);
}

class AuthStateSignInError extends AuthState {
  final String? errorMessage;

  const AuthStateSignInError(this.errorMessage);
}

class AuthStateNavigateToSignUp extends AuthState {
  const AuthStateNavigateToSignUp();
}

class AuthStateNavigateToSignIn extends AuthState {
  const AuthStateNavigateToSignIn();
}
