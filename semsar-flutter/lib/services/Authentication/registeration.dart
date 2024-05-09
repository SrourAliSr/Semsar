import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:semsar/Models/check%20error/check_error_registeration.dart';
import 'package:semsar/Models/registeration_model.dart';
import 'package:semsar/constants/backend_url.dart';
import 'package:semsar/constants/tokens.dart';
import 'package:semsar/services/houses/house_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  Future<CheckErrorRegisteration> signUp({
    required String email,
    required String password,
  }) async {
    CheckErrorRegisteration error = CheckErrorRegisteration();

    try {
      RegisterationModel signUpModel =
          RegisterationModel(email: email, password: password);

      final jsonFormat = jsonEncode(signUpModel.toMap());

      final request = await http.post(
        Uri.parse('$backendUrl/register'),
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
        },
        body: jsonFormat,
      );

      if (request.statusCode == 200) {
        error.sucess = true;

        error.errorMessage = null;

        return error;
      }
      Map<String, dynamic> decodeExeption = jsonDecode(request.body);

      final errorMessage =
          (decodeExeption['errors'] as Map<String, dynamic>).keys.toList()[0];

      throw Exception(errorMessage);
    } catch (e) {
      error.sucess = false;

      error.errorMessage = e.toString().replaceFirst('Exception: ', '');

      return error;
    }
  }

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

      error.errorMessage = e.toString().replaceFirst('Exception: ', '');

      return error;
    }
  }

  Future<String?> getUserId() async {
    final token = Tokens.token;
    HouseServices services = HouseServices();

    if (token == null) {
      await services.refreshToken();
    }

    final pref = await SharedPreferences.getInstance();

    final email = pref.getString('email');

    if (email == null || email == '') {
      return null;
    }
    final response = await http.get(
      Uri.parse('$backendUrl/api/User?email=$email'),
      headers: {'Auhtorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 401) {
      await services.refreshToken();

      return await getUserId();
    } else {
      return null;
    }
  }
}
