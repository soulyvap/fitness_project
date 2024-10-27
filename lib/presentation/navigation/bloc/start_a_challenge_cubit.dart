import 'package:fitness_project/data/db/models/get_groups_by_user_req.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/usecases/db/get_all_exercises.dart';
import 'package:fitness_project/domain/usecases/db/get_groups_by_user.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StartAChallengeState {}

class StartAChallengeLoading extends StartAChallengeState {}

class StartAChallengeLoaded extends StartAChallengeState {
  final List<GroupEntity> groups;
  final List<ExerciseEntity> exercises;
  StartAChallengeLoaded(this.groups, this.exercises);
}

class StartAChallengeError extends StartAChallengeState {
  final String errorMessage;
  StartAChallengeError(this.errorMessage);
}

class StartAChallengeCubit extends Cubit<StartAChallengeState> {
  final String currentUserId;
  StartAChallengeCubit(this.currentUserId) : super(StartAChallengeLoading()) {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final groups = await _fetchGroups();
      final exercises = await _fetchExercises();
      if (groups != null && exercises != null) {
        Future.delayed(const Duration(seconds: 1));
        emit(StartAChallengeLoaded(groups, exercises));
      } else {
        emit(StartAChallengeError('Failed to load data'));
      }
    } catch (e) {
      emit(StartAChallengeError(e.toString()));
    }
  }

  Future<List<GroupEntity>?> _fetchGroups() async {
    final groups = await sl<GetGroupsByUserUseCase>()
        .call(params: GetGroupsByUserReq(userId: currentUserId));
    List<GroupEntity>? returnValue;
    groups.fold((error) {
      emit(StartAChallengeError('Failed to load groups'));
      returnValue = null;
    }, (data) {
      returnValue = data;
    });
    return returnValue;
  }

  Future<List<ExerciseEntity>?> _fetchExercises() async {
    final exercises = await sl<GetAllExercisesUseCase>().call();
    List<ExerciseEntity>? returnValue;
    exercises.fold((error) {
      emit(StartAChallengeError('Failed to load exercises'));
      returnValue = null;
    }, (data) {
      returnValue = data;
    });
    return returnValue;
  }
}
