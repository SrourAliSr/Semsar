import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState(
      {required this.isLoading, this.loadingText = "Please wait a moment"});
}

class AuthStateInit extends AuthState {
  const AuthStateInit({required super.isLoading});
}

class AuthStateSignUp extends AuthState {
  const AuthStateSignUp({required super.isLoading});
}

class AuthStateSignIn extends AuthState {
  final Exception? exception;
  const AuthStateSignIn({this.exception, required super.isLoading});
}

class AuthStateLogout extends AuthState {
  final Exception? exception;
  const AuthStateLogout({
    this.exception,
    super.loadingText,
    required super.isLoading,
  });
}

class AuthStateSignUpError extends AuthState {
  final Exception? exception;

  const AuthStateSignUpError({this.exception, required super.isLoading});
}

class AuthStateSignInError extends AuthState {
  final Exception? exception;

  const AuthStateSignInError({this.exception, required super.isLoading});
}

class AuthStateNavigateToSignUp extends AuthState {
  const AuthStateNavigateToSignUp(
      {super.loadingText, required super.isLoading});
}

class AuthStateNavigateToSignIn extends AuthState {
  const AuthStateNavigateToSignIn({required super.isLoading});
}

class AuthStateNavigateToSettings extends AuthState {
  const AuthStateNavigateToSettings({required super.isLoading});
}

class AuthStateNavigateToHomePage extends AuthState {
  const AuthStateNavigateToHomePage({required super.isLoading});
}

class AuthStateNavigateToSavedPosts extends AuthState {
  const AuthStateNavigateToSavedPosts({required super.isLoading});
}
