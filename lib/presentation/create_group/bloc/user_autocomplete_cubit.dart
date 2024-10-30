import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';
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
        },
      );
    } catch (e) {
      emit([]);
    }
  }
}
