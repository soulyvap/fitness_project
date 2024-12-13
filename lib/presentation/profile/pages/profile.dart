import 'package:fitness_project/common/bloc/need_refresh_cubit.dart';
import 'package:fitness_project/common/bloc/user_cubit.dart';
import 'package:fitness_project/domain/usecases/auth/logout.dart';
import 'package:fitness_project/presentation/start/pages/login.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<NeedRefreshCubit>().setValue(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        leading: const BackButton(),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(builder: (context) {
              var userState = context.read<UserCubit>().state;
              if (userState is! UserLoaded) {
                return const CircularProgressIndicator();
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: userState.user.image == null
                        ? null
                        : NetworkImage(userState.user.image!),
                    radius: 100,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: userState.user.image == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(userState.user.displayName,
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(userState.user.email),
                ],
              );
            }),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () async {
                  context.read<UserCubit>().clear();
                  var result = await sl<LogoutUseCase>().call();
                  result.fold(
                      (error) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                            ),
                          ), (data) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => route.isFirst,
                    );
                  });
                },
                child: const Text("Logout")),
          ],
        ),
      ),
    );
  }
}
