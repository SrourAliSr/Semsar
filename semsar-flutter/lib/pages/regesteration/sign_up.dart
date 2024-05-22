import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semsar/constants/app_colors.dart';
import 'package:semsar/services/Authentication/authentication.dart';
import 'package:semsar/services/Authentication/bloc/auth_bloc.dart';
import 'package:semsar/services/Authentication/bloc/auth_event.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController email;

  late TextEditingController password;

  late TextEditingController username;

  late TextEditingController phoneNumber;

  Authentication registeration = Authentication();

  bool isObsecurePassword = true;

  @override
  void initState() {
    email = TextEditingController();

    password = TextEditingController();

    username = TextEditingController();

    phoneNumber = TextEditingController();

    registeration = Authentication();

    super.initState();
  }

  @override
  void dispose() {
    email.dispose();

    password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: const [
            Image(
              image: AssetImage(
                'assets/images/dealers.png',
              ),
              width: double.infinity,
            ),
            ColoredBox(
              color: Color.fromARGB(255, 255, 244, 237),
              child: SizedBox(
                height: 600,
              ),
            )
          ],
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              children: [
                const SizedBox(
                  height: 160,
                ),
                const Text(
                  'Let\'s get you signed up!',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Enter you info below.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: size.width - 50,
                  padding: const EdgeInsets.all(23.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.withOpacity(
                              0.8,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/icons/google_icon.png',
                              ),
                              width: 35,
                            ),
                            Text(
                              'Sign up using Google!',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ColoredBox(
                            color: Color.fromARGB(127, 158, 158, 158),
                            child: SizedBox(
                              width: 120,
                              height: 1,
                            ),
                          ),
                          Text(
                            'OR',
                            style: TextStyle(
                              color: AppColors.lightBrown,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ColoredBox(
                            color: Color.fromARGB(127, 158, 158, 158),
                            child: SizedBox(
                              width: 120,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.38,
                            child: TextField(
                              controller: username,
                              autocorrect: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                labelText: 'Username',
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: size.width * 0.38,
                            child: TextField(
                              controller: phoneNumber,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                labelText: 'Phone Number',
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
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
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: password,
                        autocorrect: false,
                        obscureText: isObsecurePassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObsecurePassword = !isObsecurePassword;
                              });
                            },
                            icon: const Icon(
                              Icons.remove_red_eye_outlined,
                            ),
                          ),
                          labelText: 'password',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                AuthEventSignUp(
                                  email.text,
                                  password.text,
                                  username.text,
                                  phoneNumber.text,
                                ),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkBrown,
                          minimumSize: const Size(
                            double.infinity,
                            50,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'sign in here!',
                                style: const TextStyle(
                                  color: AppColors.lightBrown,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context
                                        .read<AuthBloc>()
                                        .add(const AuthEventNavigateToSignIn());
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
