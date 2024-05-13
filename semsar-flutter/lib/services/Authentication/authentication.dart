import 'package:semsar/Models/check%20error/check_error_registeration.dart';
import 'package:semsar/Models/user.dart';
import 'package:semsar/services/Authentication/auth_abstract.dart';
import 'package:semsar/services/Authentication/auth_logic.dart';

class Authentication implements AuthAbstract {
  final AuthLogic _auth = AuthLogic();

  @override
  Future<CheckErrorRegisteration> signUp({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
  }) async =>
      await _auth.signUp(
        email: email,
        password: password,
        username: username,
        phoneNumber: phoneNumber,
      );

  @override
  Future<CheckErrorRegisteration> signIn({
    required String email,
    required String password,
  }) async =>
      await _auth.signIn(
        email: email,
        password: password,
      );

  @override
  Future<User?> getUser(String email) async => await _auth.getUser(email);
}
