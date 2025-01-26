import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/usecases/db/get_users_by_ids.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CompletedByState {}

class CompletedByInitial extends CompletedByState {}

class CompletedByLoading extends CompletedByState {}

class CompletedByLoaded extends CompletedByState {
  final List<UserEntity> users;
  CompletedByLoaded(this.users);
}

class CompletedByError extends CompletedByState {
  final String errorMessage;
  CompletedByError(this.errorMessage);
}

class CompletedByCubit extends Cubit<CompletedByState> {
  final List<String> userIds;
  CompletedByCubit({required this.userIds}) : super(CompletedByInitial());

  Future<void> loadData() async {
    emit(CompletedByLoading());
    try {
      final users = await sl<GetUsersByIdsUseCase>().call(params: userIds);
      users.fold(
        (l) => emit(CompletedByError('Failed to load users')),
        (r) => emit(CompletedByLoaded(r)),
      );
    } catch (e) {
      emit(CompletedByError('Failed to load users'));
    }
  }
}
