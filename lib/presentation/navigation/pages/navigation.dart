import 'package:fitness_project/presentation/navigation/widgets/bottom_bar.dart';
import 'package:fitness_project/presentation/navigation/bloc/nav_index_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/pages/home.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NavIndexCubit(),
        child: BlocBuilder<NavIndexCubit, int>(
          builder: (context, state) {
            return Scaffold(
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
  }
}
