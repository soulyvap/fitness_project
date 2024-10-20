import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/usecases/auth/get_user.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UserEvent {}

class LoadUser extends UserEvent {}

abstract class UserState {}

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

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserLoading()) {
    on<LoadUser>(_onUserLoaded);
    add(LoadUser());
  }

  Future<void> _onUserLoaded(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await sl<GetUserUseCase>().call();
      user.fold((error) {
        emit(UserNotFound());
      }, (data) {
        emit(UserLoaded(data));
      });
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
