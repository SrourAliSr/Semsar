import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:semsar/Models/check%20error/check_error_registeration.dart';
import 'package:semsar/pages/home/home_page.dart';
import 'package:semsar/pages/regesteration/sign_up.dart';
import 'package:semsar/services/Authentication/registeration.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController email;

  late TextEditingController password;

  Authentication registeration = Authentication();

  late bool isError;

  late String? error;

  @override
  void initState() {
    email = TextEditingController();

    password = TextEditingController();

    registeration = Authentication();

    isError = false;

    error = null;

    super.initState();
  }

  @override
  void dispose() {
    email.dispose();

    password.dispose();

    isError = false;

    error = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: size.width - 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                      controller: password,
                      autocorrect: false,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        labelText: 'password',
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'dont you have an account? ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'sign up here!',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (isError)
                      ? Text(
                          error ?? "",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 213, 18, 4),
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final CheckErrorRegisteration operation =
                          await registeration.signIn(
                        email: email.text,
                        password: password.text,
                      );

                      if (!operation.sucess) {
                        setState(() {
                          isError = !operation.sucess;

                          error = operation.errorMessage;
                        });
                      }
                      if (operation.sucess) {
                        setState(() {
                          isError = !operation.sucess;

                          error = operation.errorMessage;
                        });
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 4,
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: const Center(
                        child: Text('Sign in'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
