import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/bloc/user_bloc.dart';
import 'package:fitness_project/presentation/auth/pages/login.dart';
import 'package:fitness_project/presentation/create_account/pages/create_account.dart';
import 'package:fitness_project/presentation/create_group/pages/create_group.dart';
import 'package:fitness_project/presentation/navigation/widgets/bottom_bar.dart';
import 'package:fitness_project/presentation/navigation/bloc/nav_index_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/pages/home.dart';

class Navigation extends StatelessWidget {
  final int? initialIndex;
  const Navigation({super.key, this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        return const LoginPage();
      } else if (state is UserLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (state is UserNotFound) {
        return CreateAccountPage(
            userId: authUser.uid, userEmail: authUser.email ?? "no email");
      } else if (state is UserLoaded) {
        return BlocProvider(
            create: (context) => NavIndexCubit(initialIndex),
            child: BlocBuilder<NavIndexCubit, int>(
              builder: (context, state) {
                return Scaffold(
                  floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CreateGroupPage()));
                      },
                      child: const Icon(Icons.add)),
                  body: IndexedStack(
                    index: state,
                    children: const [
                      HomePage(),
                      Center(
                        child: Text("Find Page"),
                      ),
                      Center(
                        child: Text("Profile Page"),
                      ),
                      Center(
                        child: Text("Alerts Page"),
                      ),
                    ],
                  ),
                  bottomNavigationBar: BottomBar(
                    navIndex: state,
                    setIndex: (index) =>
                        context.read<NavIndexCubit>().setIndex(index),
                  ),
                );
              },
            ));
      } else if (state is UserError) {
        return Center(
          child: Text(state.errorMessage),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
