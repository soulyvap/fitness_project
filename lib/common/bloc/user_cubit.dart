import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/usecases/db/get_user.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserEntity user;
  UserLoaded(this.user);
}

class UserNotFound extends UserState {}

class UserError extends UserState {
  final String errorMessage;
  UserError(this.errorMessage);
}

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Future<void> loadUser(String userId) async {
    emit(UserLoading());
    try {
      final user = await sl<GetUserUseCase>().call(params: userId);
      user.fold((error) {
        debugPrint(error);
        emit(UserNotFound());
      }, (data) {
        emit(UserLoaded(data));
      });
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void clear() {
    emit(UserInitial());
  }
}
