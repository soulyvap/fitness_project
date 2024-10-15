import 'dart:developer';
import 'package:fitness_project/domain/entities/auth/user.dart';
import 'package:fitness_project/domain/usecases/auth/logout.dart';
import 'package:fitness_project/presentation/auth/pages/login.dart';
import 'package:fitness_project/presentation/create_group/pages/create_group.dart';
import 'package:fitness_project/presentation/home/bloc/user_info_cubit.dart';
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
    return BlocProvider(
      create: (context) => UserInfoCubit(navigateToPage),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateGroupPage()));
            },
            child: const Icon(Icons.add)),
        body: BlocBuilder<UserInfoCubit, UserEntity?>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Home Page"),
                  ElevatedButton(
                      onPressed: () async {
                        var result = await sl<LogoutUseCase>().call();
                        result.fold(
                            (error) =>
                                ScaffoldMessenger.of(context).showSnackBar(
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
          },
        ),
      ),
    );
  }
}
