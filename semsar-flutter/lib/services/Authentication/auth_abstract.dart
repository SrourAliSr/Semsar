import 'package:semsar/Models/check%20error/check_error_registeration.dart';

abstract class AuthAbstract {
  Future<CheckErrorRegisteration> signUp({
    required String email,
    required String password,
  });

  Future<CheckErrorRegisteration> signIn({
    required String email,
    required String password,
  });

  Future<String?> getUserId();
}
