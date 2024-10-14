import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/domain/entities/auth/user.dart';
import 'package:fitness_project/domain/repository/auth/auth.dart';
import 'package:fitness_project/presentation/auth/pages/login.dart';
import 'package:fitness_project/presentation/create_account/pages/create_account.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInfoCubit extends Cubit<UserEntity?> {
  final Function(Widget) navigateToPage;

  UserInfoCubit(this.navigateToPage) : super(null) {
    getUser();
  }

  void getUser() async {
    var user = await sl<AuthRepository>().getUser();
    user.fold((error) {
      emit(null);
      var userId = FirebaseAuth.instance.currentUser?.uid;
      navigateToPage(userId == null
          ? const LoginPage()
          : CreateAccountPage(userId: userId));
    }, (data) {
      emit(data);
    });
  }
}
