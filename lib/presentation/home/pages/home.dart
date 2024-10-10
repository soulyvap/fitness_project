import 'dart:developer';

import 'package:fitness_project/domain/usecases/auth/logout.dart';
import 'package:fitness_project/presentation/auth/pages/login.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Home Page"),
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
