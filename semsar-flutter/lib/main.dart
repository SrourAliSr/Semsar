import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semsar/constants/app_colors.dart';
import 'package:semsar/pages/home/home_page.dart';
import 'package:semsar/pages/regesteration/sign_in.dart';
import 'package:semsar/pages/regesteration/sign_up.dart';
import 'package:semsar/routes/generated_routes.dart';
import 'package:semsar/services/Authentication/authentication.dart';
import 'package:semsar/services/Authentication/bloc/auth_bloc.dart';
import 'package:semsar/services/Authentication/bloc/auth_event.dart';
import 'package:semsar/services/Authentication/bloc/auth_state.dart';

void main() {
  HttpOverrides.global = DevHttpOverrides();
  AppRoutes routes = AppRoutes();
  runApp(
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(Authentication()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Open-Sans',
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.cinderella),
          useMaterial3: true,
        ),
        home: const MainRoute(),
        onGenerateRoute: (settings) => routes.onGeneratedRoute(settings),
      ),
    ),
  );
}

class MainRoute extends StatelessWidget {
  const MainRoute({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInit());
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLogout) {
          return const SignInPage();
        } else if (state is AuthStateSignIn) {
          return const HomePage();
        } else if (state is AuthStateSignUp) {
          return const SignUpPage();
        } else if (state is AuthStateSignInError) {
          return SignInPage(
            errorMessage: state.errorMessage,
          );
        } else if (state is AuthStateSignUpError) {
          return SignUpPage(
            errorMessage: state.errorMessage,
          );
        } else if (state is AuthStateNavigateToSignUp) {
          return const SignUpPage();
        } else if (state is AuthStateNavigateToSignIn) {
          return const SignInPage();
        }
        return Container();
      },
      listener: (context, state) {},
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
