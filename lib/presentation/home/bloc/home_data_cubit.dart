import 'package:fitness_project/data/db/models/get_challenges_by_groups_req.dart';
import 'package:fitness_project/data/db/models/get_groups_by_user_req.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/usecases/db/get_all_exercises.dart';
import 'package:fitness_project/domain/usecases/db/get_challenges_by_groups.dart';
import 'package:fitness_project/domain/usecases/db/get_groups_by_user.dart';
import 'package:fitness_project/domain/usecases/db/get_submissions_by_groups.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeDataState {}

class HomeDataLoading extends HomeDataState {}

class HomeDataLoaded extends HomeDataState {
  final List<GroupEntity> myGroups;
  final List<ChallengeEntity> activeChallenges;
  final List<ChallengeEntity> previousChallenges;
  final List<ExerciseEntity> allExercises;
  final List<SubmissionEntity> activeSubmissions;

  HomeDataLoaded(this.myGroups, this.activeChallenges, this.previousChallenges,
      this.allExercises, this.activeSubmissions);
}

class HomeDataError extends HomeDataState {
  final String errorMessage;

  HomeDataError(this.errorMessage);
}

class HomeDataCubit extends Cubit<HomeDataState> {
  final UserEntity currentUser;
  HomeDataCubit(this.currentUser) : super(HomeDataLoading()) {
    loadData();
  }

  Future<void> loadData() async {
    try {
      final mygroups = await _fetchMyGroups();
      if (mygroups == null) {
        emit(HomeDataError('Failed to load groups'));
        return;
      }
      if (mygroups.isEmpty) {
        emit(HomeDataLoaded([], [], [], [], []));
        return;
      }
      final groupsWhereIamMember = mygroups
          .where((element) => element.members.contains(currentUser.userId))
          .toList();
      final myChallenges = await _fetchMyChallenges(
          groupsWhereIamMember.map((e) => e.groupId).toList());
      if (myChallenges == null) {
        emit(HomeDataError('Failed to load challenges'));
        return;
      }
      final allExercises = await _fetchAllExercises();
      if (allExercises == null) {
        emit(HomeDataError('Failed to load exercises'));
        return;
      }

      final activeSubmissions = await _fetchSubmissions(
          groupsWhereIamMember.map((e) => e.groupId).toList());

      if (activeSubmissions == null) {
        emit(HomeDataError('Failed to load submissions'));
        return;
      }

      final activeChallenges = myChallenges
          .where((element) => element.endsAt.isAfter(DateTime.now()))
          .toList();
      final previousChallenges = myChallenges
          .where((element) => element.endsAt.isBefore(DateTime.now()))
          .toList();

      emit(HomeDataLoaded(mygroups, activeChallenges, previousChallenges,
          allExercises, activeSubmissions));
    } catch (e) {
      emit(HomeDataError(e.toString()));
    }
  }

  Future<List<GroupEntity>?> _fetchMyGroups() async {
    final groups = await sl<GetGroupsByUserUseCase>()
        .call(params: GetGroupsByUserReq(userId: currentUser.userId));
    List<GroupEntity>? myGroups;
    groups.fold((error) {
      emit(HomeDataError('Failed to load groups $error'));
      myGroups = null;
    }, (data) {
      myGroups = data;
    });
    return myGroups;
  }

  Future<List<ChallengeEntity>?> _fetchMyChallenges(
      List<String> groupIds) async {
    final challenges = await sl<GetChallengesByGroupsUseCase>().call(
        params:
            GetChallengesByGroupsReq(groupIds: groupIds, onlyActive: false));
    List<ChallengeEntity>? myChallenges;
    challenges.fold((error) {
      emit(HomeDataError('Failed to load challenges $error'));
      myChallenges = null;
    }, (data) {
      myChallenges = data;
    });
    return myChallenges;
  }

  Future<List<ExerciseEntity>?> _fetchAllExercises() async {
    final exercises = await sl<GetAllExercisesUseCase>().call();
    List<ExerciseEntity>? allExercises;
    exercises.fold((error) {
      emit(HomeDataError('Failed to load exercises $error'));
      allExercises = null;
    }, (data) {
      allExercises = data;
    });
    return allExercises;
  }

  Future<List<SubmissionEntity>?> _fetchSubmissions(
      List<String> groupIds) async {
    final submissions =
        await sl<GetSubmissionsByGroupsUseCase>().call(params: groupIds);

    List<SubmissionEntity>? activeSubmissions;

    submissions.fold((error) {
      emit(HomeDataError('Failed to load submissions: $error'));
      activeSubmissions = null;
    }, (data) {
      activeSubmissions = data;
    });

    return activeSubmissions;
  }
}
