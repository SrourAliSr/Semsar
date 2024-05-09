import 'dart:io';
import 'package:flutter/material.dart';
import 'package:semsar/constants/app_colors.dart';
import 'package:semsar/pages/home/home_page.dart';
import 'package:semsar/pages/regesteration/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  HttpOverrides.global = DevHttpOverrides();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.cinderella),
        useMaterial3: true,
      ),
      home: const MainRoute(),
    ),
  );
}

class MainRoute extends StatelessWidget {
  const MainRoute({super.key});

  Future check(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var peref = snapshot.data!;

          var data = peref.getString('email');

          if (data == null) {
            return const SignInPage();
          }

          return const HomePage();
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
