import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:fitness_project/presentation/navigation/pages/navigation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Navigation()),
              (route) => route is Navigation);
        }),
      ],
    );
  }
}
