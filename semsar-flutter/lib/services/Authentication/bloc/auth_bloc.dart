import 'package:bloc/bloc.dart';
import 'package:semsar/Models/check%20error/check_error_registeration.dart';
import 'package:semsar/Models/user.dart';
import 'package:semsar/constants/user_settings.dart';
import 'package:semsar/services/Authentication/authentication.dart';
import 'package:semsar/services/Authentication/bloc/auth_event.dart';
import 'package:semsar/services/Authentication/bloc/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(Authentication auth) : super(const AuthStateInit()) {
    on<AuthEventInit>(
      (event, emit) async {
        var pref = await SharedPreferences.getInstance();

        final userId = pref.getString('userId');

        if (userId == null || userId == '') {
          emit(const AuthStateLogout());
        } else {
          final email = pref.getString('email');

          final username = pref.getString('username');

          final phoneNumber = pref.getString('phoneNumber');

          final User user = User(
            userId: userId,
            email: email!,
            userName: username ?? "",
            phoneNumber: phoneNumber ?? "",
          );

          UserSettings.user = user;

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
          final user = await auth.getUser(event.email);

          var pref = await SharedPreferences.getInstance();

          await pref.setString('userId', user!.userId);

          await pref.setString('email', user.email);

          await pref.setString('username', user.userName);

          await pref.setString('phoneNumber', user.phoneNumber);

          UserSettings.user = user;

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
        username: event.username,
        phoneNumber: event.phoneNumber,
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
    on<AuthEventNavigateToSettings>(
      (event, emit) => emit(
        const AuthStateNavigateToSettings(),
      ),
    );
    on<AuthEventNavigateToHomePage>(
      (event, emit) => emit(
        const AuthStateNavigateToHomePage(),
      ),
    );
    on<AuthEventNavigateToSavedPosts>(
      (event, emit) => emit(
        const AuthStateNavigateToSavedPosts(),
      ),
    );
  }
}
