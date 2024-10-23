import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/usecases/db/get_challenge_by_id.dart';
import 'package:fitness_project/domain/usecases/db/get_exercise_by_id.dart';
import 'package:fitness_project/domain/usecases/db/get_group_by_id.dart';
import 'package:fitness_project/domain/usecases/db/get_user.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChallengePreviewState {}

class Loading extends ChallengePreviewState {}

class Loaded extends ChallengePreviewState {
  final ChallengeEntity challenge;
  final GroupEntity group;
  final UserEntity author;
  final ExerciseEntity exercise;
  Loaded(this.challenge, this.group, this.author, this.exercise);
}

class Error extends ChallengePreviewState {
  final String errorMessage;
  Error(this.errorMessage);
}

class ChallengePreviewCubit extends Cubit<ChallengePreviewState> {
  final String challengeId;
  ChallengePreviewCubit({required this.challengeId}) : super(Loading()) {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final challenge = await _fetchChallenge(challengeId);
      if (challenge == null) {
        emit(Error('Failed to load challenges'));
        return;
      }
      final group = await _fetchGroup(challenge.groupId);
      if (group == null) {
        emit(Error('Failed to load group'));
        return;
      }
      final author = await _fetchAuthor(challenge.userId);
      if (author == null) {
        emit(Error('Failed to load author'));
        return;
      }
      final exercise = await _fetchExercise(challenge.exerciseId);
      if (exercise == null) {
        emit(Error('Failed to load exercise'));
        return;
      }
      emit(Loaded(challenge, group, author, exercise));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  Future<ChallengeEntity?> _fetchChallenge(String challengeId) async {
    final challenge =
        await sl<GetChallengeByIdUseCase>().call(params: challengeId);
    ChallengeEntity? challengeEntity;
    challenge.fold((error) {
      emit(Error(error));
    }, (data) {
      if (data == null) {
        emit(Error('Challenge not found'));
        return;
      }
      challengeEntity = data;
    });
    return challengeEntity;
  }

  Future<GroupEntity?> _fetchGroup(String groupId) async {
    final group = await sl<GetGroupByIdUseCase>().call(params: groupId);
    GroupEntity? groupEntity;
    group.fold((error) {
      emit(Error(error));
    }, (data) {
      if (data == null) {
        emit(Error('Group not found'));
        return;
      }
      groupEntity = data;
    });
    return groupEntity;
  }

  Future<UserEntity?> _fetchAuthor(String authorId) async {
    final author = await sl<GetUserUseCase>().call(params: authorId);
    UserEntity? authorEntity;
    author.fold((error) {
      emit(Error(error));
    }, (data) {
      if (data == null) {
        emit(Error('Author not found'));
        return;
      }
      authorEntity = data;
    });
    return authorEntity;
  }

  Future<ExerciseEntity?> _fetchExercise(String exerciseId) async {
    final exercise =
        await sl<GetExerciseByIdUseCase>().call(params: exerciseId);
    ExerciseEntity? exerciseEntity;
    exercise.fold((error) {
      emit(Error(error));
    }, (data) {
      if (data == null) {
        emit(Error('Exercise not found'));
        return;
      }
      exerciseEntity = data;
    });
    return exerciseEntity;
  }
}
