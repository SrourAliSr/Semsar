import 'package:flutter/material.dart';
import 'package:semsar/pages/regesteration/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  SharedPreferences.getInstance().then(
                    (value) => value.clear().then(
                      (value) {
                        if (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
                child: const Text('LogOut'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
