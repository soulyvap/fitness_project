import 'package:fitness_project/common/bloc/user_bloc.dart';
import 'package:fitness_project/domain/usecases/auth/logout.dart';
import 'package:fitness_project/presentation/auth/pages/login.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void navigateToPage(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            if (state is UserLoaded) {
              return Column(
                children: [
                  Text("Welcome ${state.user.displayName}"),
                  Text("Email: ${state.user.email}"),
                  Text("User ID: ${state.user.userId}"),
                ],
              );
            }
            return const CircularProgressIndicator();
          }),
          ElevatedButton(
              onPressed: () async {
                var result = await sl<LogoutUseCase>().call();
                result.fold(
                    (error) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                          ),
                        ),
                    (data) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        ));
              },
              child: const Text("Logout"))
        ],
      ),
    );
  }
}
