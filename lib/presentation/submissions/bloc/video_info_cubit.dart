import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/usecases/db/get_challenge_by_id.dart';
import 'package:fitness_project/domain/usecases/db/get_exercise_by_id.dart';
import 'package:fitness_project/domain/usecases/db/get_group_by_id.dart';
import 'package:fitness_project/domain/usecases/db/get_user.dart';
import 'package:fitness_project/presentation/challenge/bloc/challenge_details_cubit.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class VideoInfoState {}

class VideoInfoInitial extends VideoInfoState {}

class VideoInfoLoading extends VideoInfoState {}

class VideoInfoLoaded extends VideoInfoState {
  final ChallengeEntity challenge;
  final GroupEntity group;
  final UserEntity challenger;
  final ExerciseEntity exercise;

  VideoInfoLoaded(
      {required this.challenge,
      required this.group,
      required this.challenger,
      required this.exercise});
}

class VideoInfoError extends VideoInfoState {
  final String errorMessage;

  VideoInfoError(this.errorMessage);
}

class VideoInfoCubit extends Cubit<VideoInfoState> {
  final SubmissionEntity submission;
  VideoInfoCubit({required this.submission}) : super(VideoInfoInitial()) {
    loadData();
  }

  Future<void> loadData() async {
    try {
      emit(VideoInfoLoading());
      final challenge = await _fetchChallenge(submission.challengeId);

      if (challenge == null) {
        emit(VideoInfoError('Failed to load challenges'));
        return;
      }

      final group = await _fetchGroup(challenge.groupId);

      if (group == null) {
        emit(VideoInfoError('Failed to load group'));
        return;
      }

      final author = await _fetchAuthor(challenge.userId);

      if (author == null) {
        emit(VideoInfoError('Failed to load author'));
        return;
      }

      final exercise = await _fetchExercise(challenge.exerciseId);

      if (exercise == null) {
        emit(VideoInfoError('Failed to load exercise'));
        return;
      }

      emit(VideoInfoLoaded(
          challenge: challenge,
          group: group,
          challenger: author,
          exercise: exercise));
    } catch (e) {
      emit(VideoInfoError(e.toString()));
    }
  }

  Future<ChallengeEntity?> _fetchChallenge(String challengeId) async {
    final challenge =
        await sl<GetChallengeByIdUseCase>().call(params: challengeId);
    ChallengeEntity? challengeEntity;
    challenge.fold((error) {
      emit(VideoInfoError(error));
    }, (data) {
      if (data == null) {
        emit(VideoInfoError('Challenge not found'));
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
      emit(VideoInfoError(error));
    }, (data) {
      if (data == null) {
        emit(VideoInfoError('Group not found'));
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
      emit(VideoInfoError(error));
    }, (data) {
      if (data == null) {
        emit(VideoInfoError('Author not found'));
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
      emit(VideoInfoError(error));
    }, (data) {
      if (data == null) {
        emit(VideoInfoError('Exercise not found'));
        return;
      }
      exerciseEntity = data;
    });
    return exerciseEntity;
  }
}
