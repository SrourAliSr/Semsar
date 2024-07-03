import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:semsar/Models/message.dart';
import 'package:semsar/Models/user.dart';
import 'package:semsar/constants/hub_connection.dart';
import 'package:semsar/constants/tokens.dart';
import 'package:semsar/constants/user_settings.dart';
import 'package:semsar/services/Authentication/authentication.dart';
import 'package:semsar/services/Authentication/bloc/auth_event.dart';
import 'package:semsar/services/Authentication/bloc/auth_state.dart';
import 'package:semsar/services/curd/crud_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(Authentication auth) : super(const AuthStateInit(isLoading: false)) {
    on<AuthEventInit>(
      (event, emit) async {
        var pref = await SharedPreferences.getInstance();

        final userId = pref.getString('userId');

        if (userId == null || userId == '') {
          emit(const AuthStateLogout(
            isLoading: false,
          ));
        } else {
          SemsarDb db = SemsarDb();

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

          try {
            emit(
              const AuthStateSignIn(
                isLoading: false,
              ),
            );
            await db.open();

            await db.getOrCreateUser(user: user);
            Timer.periodic(
              const Duration(minutes: 55),
              (timer) async {
                await auth.refreshToken();
              },
            );

            await auth.refreshToken();

            final token = Tokens.token;
            if (token == null) {
              emit(const AuthStateLogout(isLoading: false));
            } else {
              hubConnection = HubConnectionBuilder()
                  .withUrl(
                      'https://10.0.2.2:8000/chatHub?id=$token',
                      HttpConnectionOptions(
                        accessTokenFactory: () async => token,
                        logging: (level, message) => log(message),
                        transport: HttpTransportType.longPolling,
                      ))
                  .withAutomaticReconnect()
                  .build();

              try {
                await hubConnection!.start();

                final List<dynamic> messages = await hubConnection!.invoke(
                  "GetTempMessages",
                  args: [userId],
                );

                for (var message in messages) {
                  if (userId != message["senderId"]) {
                    await db.addChatRoom(
                      userId: userId,
                      reciverId: message["senderId"],
                      reciverName: message["senderName"],
                    );

                    final Message tempMessage = Message.fromMap(message);

                    await db.saveMessage(message: tempMessage);
                  }
                }

                hubConnection!.on('ReceiveMessage', (message) async {
                  log('Message Received: ${message?[0]["chatRoom"]}');

                  final newMessage = message?[0];
                  log('begin');
                  if (message?[0]["senderId"] != userId) {
                    await db.addChatRoom(
                      userId: userId,
                      reciverId: newMessage["senderId"],
                      reciverName: newMessage["senderName"],
                    );
                  }
                  final Message tempMessage = Message.fromMap(newMessage);

                  await db.saveMessage(message: tempMessage);

                  message?.map((e) async => await db.saveMessage(message: e));
                  log("start");
                });

                log('Connected to SignalR');
              } catch (e) {
                log('Connection Error: $e');
              }
            }
          } catch (e) {
            log(e.toString());
          }
        }
      },
    );
    on<AuthEventSignIn>(
      (event, emit) async {
        emit(
          const AuthStateLogout(
            exception: null,
            isLoading: true,
          ),
        );
        try {
          final response = await auth.signIn(
            email: event.email,
            password: event.password,
          );
          if (response.sucess) {
            final user = await auth.getUser(event.email);

            var pref = await SharedPreferences.getInstance();

            await pref.setString('userId', user!.userId);

            await pref.setString('email', user.email);

            await pref.setString('username', user.userName);

            await pref.setString('phoneNumber', user.phoneNumber);

            UserSettings.user = user;

            emit(
              const AuthStateSignIn(
                isLoading: false,
              ),
            );
          } else {
            throw Exception('Something went wrong');
          }
        } on Exception catch (e) {
          emit(
            AuthStateLogout(
              exception: e,
              loadingText: e.toString().split('Exception: ').last,
              isLoading: true,
            ),
          );
        }
      },
    );
    on<AuthEventLogout>(
      (event, emit) async {
        await hubConnection!.stop();

        emit(
          const AuthStateLogout(
            isLoading: true,
          ),
        );
        final pref = await SharedPreferences.getInstance();
        await pref.clear();
        emit(
          const AuthStateLogout(
            isLoading: false,
          ),
        );
      },
    );
    on<AuthEventSignUp>((event, emit) async {
      emit(
        const AuthStateNavigateToSignUp(
          isLoading: true,
        ),
      );
      final response = await auth.signUp(
        email: event.email,
        password: event.password,
        username: event.username,
        phoneNumber: event.phoneNumber,
      );
      if (!response.sucess) {
        emit(
          AuthStateNavigateToSignUp(
            loadingText: response.errorMessage.toString(),
            isLoading: true,
          ),
        );
      } else {
        emit(
          const AuthStateLogout(
            isLoading: false,
          ),
        );
      }
    });
    on<AuthEventNavigateToSignIn>(
      (event, emit) => emit(
        const AuthStateNavigateToSignIn(isLoading: false),
      ),
    );
    on<AuthEventNavigateToSignUp>(
      (event, emit) => emit(
        const AuthStateNavigateToSignUp(isLoading: false),
      ),
    );
    on<AuthEventNavigateToSettings>(
      (event, emit) => emit(
        const AuthStateNavigateToSettings(isLoading: false),
      ),
    );
    on<AuthEventNavigateToHomePage>(
      (event, emit) => emit(
        const AuthStateNavigateToHomePage(isLoading: false),
      ),
    );
    on<AuthEventNavigateToSavedPosts>(
      (event, emit) => emit(
        const AuthStateNavigateToSavedPosts(isLoading: false),
      ),
    );
  }
}
