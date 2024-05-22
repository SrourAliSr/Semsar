import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semsar/constants/app_colors.dart';
import 'package:semsar/helpers/loading_screen.dart';
import 'package:semsar/pages/Settings/settings_page.dart';
import 'package:semsar/pages/home/home_page.dart';
import 'package:semsar/pages/regesteration/sign_in.dart';
import 'package:semsar/pages/regesteration/sign_up.dart';
import 'package:semsar/pages/saved/saved_houses.dart';
import 'package:semsar/routes/generated_routes.dart';
import 'package:semsar/services/Authentication/authentication.dart';
import 'package:semsar/services/Authentication/bloc/auth_bloc.dart';
import 'package:semsar/services/Authentication/bloc/auth_event.dart';
import 'package:semsar/services/Authentication/bloc/auth_state.dart';

void main() {
  HttpOverrides.global = DevHttpOverrides();

  runApp(
    BlocProvider(
      create: (context) => AuthBloc(Authentication()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Open-Sans',
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.cinderella),
          useMaterial3: true,
        ),
        home: const MainRoute(),
        onGenerateRoute: (settings) => AppRoutes().onGeneratedRoute(settings),
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
        } else if (state is AuthStateNavigateToSignUp) {
          return const SignUpPage();
        } else if (state is AuthStateNavigateToSignIn) {
          return const SignInPage();
        } else if (state is AuthStateNavigateToSettings) {
          return const SettingsPage();
        } else if (state is AuthStateNavigateToHomePage) {
          return const HomePage();
        } else if (state is AuthStateNavigateToSavedPosts) {
          return const SavedHousesPage();
        }
        return Container();
      },
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context,
            state.loadingText ?? 'Please wait a moment',
          );
          if (state.loadingText != 'Please wait a moment') {
            // Future.delayed(const Duration(seconds: 3))
            //     .then((value) => LoadingScreen().hide());
            LoadingScreen().hide();
            showErrorAlert(
                context, state.loadingText ?? "Something went wrong");
          }
        } else {
          return LoadingScreen().hide();
        }
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

Future<void> showErrorAlert(BuildContext context, String error) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Error',
        ),
        content: Text(
          error,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'))
        ],
      );
    },
  );
}
