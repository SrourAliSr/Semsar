import 'package:semsar/Models/check%20error/check_error_registeration.dart';
import 'package:semsar/Models/user.dart';

abstract class AuthAbstract {
  Future<CheckErrorRegisteration> signUp({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
  });

  Future<CheckErrorRegisteration> signIn({
    required String email,
    required String password,
  });

  Future<User?> getUser(String email);

  Future<bool> refreshToken();
}
