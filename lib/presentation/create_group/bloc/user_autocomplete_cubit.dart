import 'package:fitness_project/domain/entities/auth/user.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAutocompleteCubit extends Cubit<List<UserEntity>?> {
  UserAutocompleteCubit() : super([]);

  void getUsers(String query) async {
    emit(null);
    try {
      var users = await sl<DBRepository>().getUsersByDisplayName(query);
      users.fold(
        (l) => emit([]),
        (r) {
          emit(r);
          debugPrint('Users: $r');
        },
      );
    } catch (e) {
      emit([]);
    }
  }
}
