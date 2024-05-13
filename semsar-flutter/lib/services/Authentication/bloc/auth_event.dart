import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInit extends AuthEvent {
  const AuthEventInit();
}

class AuthEventSignIn extends AuthEvent {
  final String email;
  final String password;

  const AuthEventSignIn({
    required this.email,
    required this.password,
  });
}

class AuthEventSignUp extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String phoneNumber;

  const AuthEventSignUp(
    this.email,
    this.password,
    this.username,
    this.phoneNumber,
  );
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

class AuthEventNavigateToSignUp extends AuthEvent {
  const AuthEventNavigateToSignUp();
}

class AuthEventNavigateToSignIn extends AuthEvent {
  const AuthEventNavigateToSignIn();
}

class AuthEventNavigateToSettings extends AuthEvent {
  const AuthEventNavigateToSettings();
}

class AuthEventNavigateToHomePage extends AuthEvent {
  const AuthEventNavigateToHomePage();
}

class AuthEventNavigateToSavedPosts extends AuthEvent {
  const AuthEventNavigateToSavedPosts();
}
