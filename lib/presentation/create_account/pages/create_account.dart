import 'package:fitness_project/common/bloc/pic_selection_cubit.dart';
import 'package:fitness_project/presentation/create_account/widgets/create_account_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountPage extends StatelessWidget {
  final String userId;
  final String userEmail;

  CreateAccountPage({super.key, required this.userId, required this.userEmail});

  final TextEditingController displayNameCon = TextEditingController();
  final TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create an account"),
      ),
      body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: BlocProvider<PicSelectionCubit>(
            create: (context) => PicSelectionCubit(),
            child: const CreateAccountForm(),
          )),
    );
  }
}
