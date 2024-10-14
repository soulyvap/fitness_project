import 'package:fitness_project/presentation/create_account/widgets/create_account_form.dart';
import 'package:flutter/material.dart';

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
      body: const SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: CreateAccountForm()),
    );
  }
}
