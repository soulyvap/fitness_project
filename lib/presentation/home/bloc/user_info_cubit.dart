import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/domain/entities/auth/user.dart';
import 'package:fitness_project/domain/usecases/auth/get_user.dart';
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
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(null);
      navigateToPage(const LoginPage());
      return;
    }
    var user = await sl<GetUserUseCase>().call();
    user.fold((error) {
      emit(null);
      navigateToPage(CreateAccountPage(
          userId: currentUser.uid, userEmail: currentUser.email ?? "no email"));
    }, (data) {
      emit(data);
    });
  }

  void onLogout() async {
    emit(null);
  }
}
