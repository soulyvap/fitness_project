import 'dart:async';

import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UserAutocompleteState {}

class UserAutocompleteInitial extends UserAutocompleteState {}

class UserAutocompleteLoading extends UserAutocompleteState {}

class UserAutocompleteLoaded extends UserAutocompleteState {
  final List<UserEntity> users;
  UserAutocompleteLoaded({required this.users});
}

class UserAutocompleteError extends UserAutocompleteState {
  final String message;
  UserAutocompleteError({required this.message});
}

class UserAutocompleteCubit extends Cubit<UserAutocompleteState> {
  UserAutocompleteCubit() : super(UserAutocompleteInitial());
  Timer? _debounce;

  void getUsers(String query) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    emit(UserAutocompleteLoading());
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        var users = await sl<DBRepository>().getUsersByDisplayName(query);
        users.fold(
          (l) =>
              emit(UserAutocompleteError(message: "Failed to fetch users: $l")),
          (r) {
            emit(UserAutocompleteLoaded(users: r));
          },
        );
      } catch (e) {
        emit(UserAutocompleteError(message: "Failed to fetch users: $e"));
      }
    });
  }

  void clear() {
    emit(UserAutocompleteInitial());
  }
}
