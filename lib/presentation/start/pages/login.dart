import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:fitness_project/common/bloc/user_cubit.dart';
import 'package:fitness_project/main.dart';
import 'package:fitness_project/presentation/navigation/pages/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> onSignIn(String userId) async {
      context.read<UserCubit>().loadUser(userId);
    }

    return SignInScreen(
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          if (state.user != null) {
            final userId = state.user!.uid;
            onSignIn(userId).then((value) {
              navigatorKey.currentState?.pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Navigation(),
                ),
              );
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Sign in failed"),
              ),
            );
          }
        }),
        AuthStateChangeAction<UserCreated>(
          (context, state) async {
            final user = state.credential.user;
            if (user != null) {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 100,
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 24),
                          SizedBox(width: 8),
                          Text("User created successfully"),
                        ],
                      ),
                    );
                  });

              Future.delayed(const Duration(seconds: 2), () {
                navigatorKey.currentState?.pop();
                navigatorKey.currentState?.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Navigation(),
                  ),
                );
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Registration failed"),
                ),
              );
            }
          },
        )
      ],
    );
  }
}
