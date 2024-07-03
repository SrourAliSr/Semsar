import 'dart:convert';

import 'package:semsar/Models/check%20error/check_error_registeration.dart';
import 'package:semsar/Models/registeration_model.dart';
import 'package:semsar/Models/user.dart';
import 'package:semsar/constants/backend_url.dart';
import 'package:semsar/constants/tokens.dart';
import 'package:semsar/services/Authentication/auth_abstract.dart';
import 'package:http/http.dart' as http;
import 'package:semsar/services/houses/house_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLogic implements AuthAbstract {
  @override
  Future<CheckErrorRegisteration> signUp({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
  }) async {
    CheckErrorRegisteration error = CheckErrorRegisteration();

    try {
      RegisterationModel signUpModel =
          RegisterationModel(email: email, password: password);

      final jsonFormat = jsonEncode(signUpModel.toMap());

      final request = await http.post(
        Uri.parse('$backendUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonFormat,
      );

      if (request.statusCode == 200) {
        await signIn(email: email, password: password);

        final token = Tokens.token;

        final newJsonFormat = {
          "email": email,
          "phoneNumber": phoneNumber,
          "username": username,
        };

        final request2 = await http.post(
          Uri.parse('$backendUrl/api/User').replace(
            queryParameters: newJsonFormat,
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        if (request2.statusCode == 200) {
          error.sucess = true;

          error.errorMessage = null;

          return error;
        }
        throw Exception(request2.body);
      }
      Map<String, dynamic> decodeExeption = jsonDecode(request.body);

      final errorMessage =
          (decodeExeption['errors'] as Map<String, dynamic>).keys.toList()[0];

      throw Exception(errorMessage);
    } catch (e) {
      error.sucess = false;

      // error.errorMessage = e.toString().replaceFirst('Exception: ', '');
      error.errorMessage = e;

      return error;
    }
  }

  @override
  Future<CheckErrorRegisteration> signIn({
    required String email,
    required String password,
  }) async {
    CheckErrorRegisteration error = CheckErrorRegisteration();

    try {
      RegisterationModel login =
          RegisterationModel(email: email, password: password);

      final String encodedLogin = jsonEncode(login.toMap());

      final request = await http.post(
        Uri.parse(
            '$backendUrl/login?useCookies=false&&useSessionCookies=false'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: encodedLogin,
      );

      if (request.statusCode == 200) {
        var prefrence = await SharedPreferences.getInstance();

        final String token = jsonDecode(request.body)['accessToken'];

        final String refreshToken = jsonDecode(request.body)['refreshToken'];

        await prefrence.setString('email', email);

        await prefrence.setString('token', token);

        await prefrence.setString('refreshToken', refreshToken);

        Tokens.token = token;

        Tokens.refToken = refreshToken;

        error.sucess = true;

        error.errorMessage = null;

        return error;
      }
      if (request.statusCode == 401) {
        throw Exception('Incorrect email or password');
      }
      throw Exception('something went wrong');
    } catch (e) {
      error.sucess = false;

      // error.errorMessage = e.toString().replaceFirst('Exception: ', '');
      error.errorMessage = e;
      rethrow;
    }
  }

  @override
  Future<User?> getUser(String email) async {
    final token = Tokens.token;
    HouseServices services = HouseServices();

    if (token == null) {
      await services.refreshToken();
    }

    final response = await http.get(
      Uri.parse('$backendUrl/api/User?email=$email'),
      headers: {'Auhtorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final User user = User.fromJson(jsonDecode(response.body));

      return user;
    } else if (response.statusCode == 401) {
      await services.refreshToken();

      return await getUser(email);
    } else {
      return null;
    }
  }

  @override
  Future<bool> refreshToken() async {
    final pref = await SharedPreferences.getInstance();

    final refToken = pref.getString("refreshToken");

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/refresh'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "refreshToken": refToken,
          },
        ),
      );
      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['accessToken'];

        final refreshToken = jsonDecode(response.body)['refreshToken'];

        Tokens.token = token;

        Tokens.refToken = refreshToken;

        await pref.setString('token', token);

        await pref.setString('refreshToken', refreshToken);

        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
