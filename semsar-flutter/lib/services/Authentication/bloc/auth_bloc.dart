import 'package:bloc/bloc.dart';
import 'package:semsar/Models/check%20error/check_error_registeration.dart';
import 'package:semsar/services/Authentication/authentication.dart';
import 'package:semsar/services/Authentication/bloc/auth_event.dart';
import 'package:semsar/services/Authentication/bloc/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(Authentication auth) : super(const AuthStateInit()) {
    on<AuthEventInit>(
      (event, emit) async {
        final peref = await SharedPreferences.getInstance();

        var data = peref.getString('email');

        if (data == null || data.isEmpty) {
          emit(const AuthStateLogout());
        } else {
          emit(const AuthStateSignIn());
        }
      },
    );
    on<AuthEventSignIn>(
      (event, emit) async {
        final CheckErrorRegisteration response = await auth.signIn(
          email: event.email,
          password: event.password,
        );
        if (!response.sucess) {
          emit(
            AuthStateSignInError(
              response.errorMessage,
            ),
          );
        } else {
          emit(const AuthStateSignIn());
        }
      },
    );
    on<AuthEventLogout>(
      (event, emit) async {
        final pref = await SharedPreferences.getInstance();
        await pref.clear();
        emit(const AuthStateLogout());
      },
    );
    on<AuthEventSignUp>((event, emit) async {
      final response = await auth.signUp(
        email: event.email,
        password: event.password,
      );
      if (!response.sucess) {
        emit(AuthStateSignUpError(response.errorMessage));
      } else {
        emit(const AuthStateLogout());
      }
    });
    on<AuthEventNavigateToSignIn>(
      (event, emit) => emit(
        const AuthStateNavigateToSignIn(),
      ),
    );
    on<AuthEventNavigateToSignUp>(
      (event, emit) => emit(
        const AuthStateNavigateToSignUp(),
      ),
    );
  }
}
