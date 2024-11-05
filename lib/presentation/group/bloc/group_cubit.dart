import 'package:fitness_project/data/models/db/get_challenges_by_groups_req.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/domain/usecases/db/get_all_exercises.dart';
import 'package:fitness_project/domain/usecases/db/get_challenges_by_groups.dart';
import 'package:fitness_project/domain/usecases/db/get_group_by_id.dart';
import 'package:fitness_project/domain/usecases/db/get_submissions_by_groups.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final GroupEntity group;
  final List<String> memberIds;
  final List<ChallengeEntity> activeChallenges;
  final List<ChallengeEntity> previousChallenges;
  final List<ExerciseEntity> allExercises;

  GroupLoaded(this.group, this.memberIds, this.activeChallenges,
      this.previousChallenges, this.allExercises);

  GroupLoaded copyWith({
    GroupEntity? group,
    List<String>? memberIds,
    List<ChallengeEntity>? activeChallenges,
    List<ChallengeEntity>? previousChallenges,
    List<ExerciseEntity>? allExercises,
  }) {
    return GroupLoaded(
      group ?? this.group,
      memberIds ?? this.memberIds,
      activeChallenges ?? this.activeChallenges,
      previousChallenges ?? this.previousChallenges,
      allExercises ?? this.allExercises,
    );
  }
}

class GroupError extends GroupState {
  final String errorMessage;

  GroupError(this.errorMessage);
}

class GroupCubit extends Cubit<GroupState> {
  final String groupId;
  GroupCubit({required this.groupId}) : super(GroupInitial()) {
    loadData();
  }

  Future<void> loadData() async {
    emit(GroupLoading());
    final group = await _fetchGroup();

    if (group == null) {
      emit(GroupError('Failed to load group'));
      return;
    }

    final myChallenges = await _fetchMyChallenges([groupId]);

    if (myChallenges == null) {
      emit(GroupError('Failed to load challenges'));
      return;
    }

    final allExercises = await _fetchAllExercises();

    if (allExercises == null) {
      emit(GroupError('Failed to load exercises'));
      return;
    }

    final activeChallenges = myChallenges
        .where((element) => element.endsAt.isAfter(DateTime.now()))
        .toList();

    final previousChallenges = myChallenges
        .where((element) => element.endsAt.isBefore(DateTime.now()))
        .toList();

    emit(GroupLoaded(group, group.members, activeChallenges, previousChallenges,
        allExercises));
  }

  Future<GroupEntity?> _fetchGroup() async {
    final group = await sl<GetGroupByIdUseCase>().call(params: groupId);
    GroupEntity? myGroup;

    group.fold((error) {
      emit(GroupError('Failed to load group $error'));
      myGroup = null;
    }, (data) {
      myGroup = data;
    });

    return myGroup;
  }

  Future<List<ChallengeEntity>?> _fetchMyChallenges(
      List<String> groupIds) async {
    final challenges = await sl<GetChallengesByGroupsUseCase>().call(
        params:
            GetChallengesByGroupsReq(groupIds: groupIds, onlyActive: false));
    List<ChallengeEntity>? myChallenges;
    challenges.fold((error) {
      emit(GroupError('Failed to load challenges $error'));
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
      emit(GroupError('Failed to load exercises $error'));
      allExercises = null;
    }, (data) {
      allExercises = data;
    });
    return allExercises;
  }
}
