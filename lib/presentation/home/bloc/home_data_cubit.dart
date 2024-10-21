import 'package:fitness_project/data/db/models/get_challenges_by_groups_req.dart';
import 'package:fitness_project/data/db/models/get_groups_by_user_req.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/usecases/db/get_all_exercises.dart';
import 'package:fitness_project/domain/usecases/db/get_challenges_by_groups.dart';
import 'package:fitness_project/domain/usecases/db/get_groups_by_user.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeDataState {}

class HomeDataLoading extends HomeDataState {}

class HomeDataLoaded extends HomeDataState {
  final List<GroupEntity> myGroups;
  final List<ChallengeEntity> myChallenges;
  final List<ExerciseEntity> allExercises;

  HomeDataLoaded(this.myGroups, this.myChallenges, this.allExercises);
}

class HomeDataError extends HomeDataState {
  final String errorMessage;

  HomeDataError(this.errorMessage);
}

class HomeDataCubit extends Cubit<HomeDataState> {
  final UserEntity currentUser;
  HomeDataCubit(this.currentUser) : super(HomeDataLoading()) {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final mygroups = await _fetchMyGroups();
      if (mygroups == null) {
        emit(HomeDataError('Failed to load groups'));
        return;
      }
      final myChallenges =
          await _fetchMyChallenges(mygroups.map((e) => e.groupId).toList());
      if (myChallenges == null) {
        emit(HomeDataError('Failed to load challenges'));
        return;
      }
      final allExercises = await _fetchAllExercises();
      if (allExercises == null) {
        emit(HomeDataError('Failed to load exercises'));
        return;
      }
      emit(HomeDataLoaded(mygroups, myChallenges, allExercises));
    } catch (e) {
      emit(HomeDataError(e.toString()));
    }
  }

  Future<List<GroupEntity>?> _fetchMyGroups() async {
    final groups = await sl<GetGroupsByUserUseCase>()
        .call(params: GetGroupsByUserReq(userId: currentUser.userId));
    List<GroupEntity>? myGroups;
    groups.fold((error) {
      emit(HomeDataError('Failed to load groups'));
      myGroups = null;
    }, (data) {
      myGroups = data;
    });
    return myGroups;
  }

  Future<List<ChallengeEntity>?> _fetchMyChallenges(
      List<String> groupIds) async {
    final challenges = await sl<GetChallengesByGroupsUseCase>()
        .call(params: GetChallengesByGroupsReq(groupIds: groupIds));
    List<ChallengeEntity>? myChallenges;
    challenges.fold((error) {
      emit(HomeDataError('Failed to load challenges'));
      myChallenges = null;
    }, (data) {
      myChallenges = data;
      debugPrint('Challenges: $myChallenges');
    });
    return myChallenges;
  }

  Future<List<ExerciseEntity>?> _fetchAllExercises() async {
    final exercises = await sl<GetAllExercisesUseCase>().call();
    List<ExerciseEntity>? allExercises;
    exercises.fold((error) {
      emit(HomeDataError('Failed to load exercises'));
      allExercises = null;
    }, (data) {
      allExercises = data;
    });
    return allExercises;
  }
}
