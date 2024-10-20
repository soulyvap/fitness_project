import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/usecases/auth/logout.dart';
import 'package:fitness_project/presentation/auth/pages/login.dart';
import 'package:fitness_project/presentation/home/bloc/home_data_cubit.dart';
import 'package:fitness_project/presentation/home/widgets/your_groups_list.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final UserEntity currentUser;
  const HomePage({super.key, required this.currentUser});
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
    return BlocProvider<HomeDataCubit>(
      create: (context) => HomeDataCubit(widget.currentUser),
      child: Builder(builder: (context) {
        final homeDataState = context.watch<HomeDataCubit>().state;
        if (homeDataState is HomeDataLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (homeDataState is HomeDataError) {
          return Center(
            child: Text(homeDataState.errorMessage),
          );
        } else if (homeDataState is HomeDataLoaded) {
          final groups = homeDataState.myGroups;
          return Scaffold(
            appBar: AppBar(
              title: const Text("Home"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Column(
                    children: [
                      Text("Welcome ${widget.currentUser.displayName}"),
                      Text("Email: ${widget.currentUser.email}"),
                      Text("User ID: ${widget.currentUser.userId}"),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  YourGroupsList(groups: groups),
                  const SizedBox(
                    height: 16,
                  ),
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
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
