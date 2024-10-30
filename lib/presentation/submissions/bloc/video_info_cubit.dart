import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/usecases/db/get_challenge_by_id.dart';
import 'package:fitness_project/domain/usecases/db/get_exercise_by_id.dart';
import 'package:fitness_project/domain/usecases/db/get_group_by_id.dart';
import 'package:fitness_project/domain/usecases/db/get_user.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoInfoData {
  final SubmissionEntity submission;
  final ChallengeEntity challenge;
  final GroupEntity group;
  final ExerciseEntity exercise;
  final UserEntity challenger;
  final UserEntity doer;
  const VideoInfoData({
    required this.submission,
    required this.challenge,
    required this.challenger,
    required this.group,
    required this.exercise,
    required this.doer,
  });
}

abstract class VideoInfoState {}

class VideoInfoInitial extends VideoInfoState {}

class VideoInfoLoading extends VideoInfoState {}

class VideoInfoLoaded extends VideoInfoState {
  final VideoInfoData data;

  VideoInfoLoaded({
    required this.data,
  });
}

class VideoInfoError extends VideoInfoState {
  final String errorMessage;

  VideoInfoError(this.errorMessage);
}

class VideoInfoCubit extends Cubit<VideoInfoState> {
  final SubmissionEntity submission;
  final VideoInfoData? data;
  VideoInfoCubit({required this.submission, this.data})
      : super(data == null ? VideoInfoInitial() : VideoInfoLoaded(data: data)) {
    if (data == null) {
      loadData();
    }
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

      final challenger = await _fetchUser(challenge.userId);

      if (challenger == null) {
        emit(VideoInfoError('Failed to load author'));
        return;
      }

      final doer = await _fetchUser(submission.userId);

      if (doer == null) {
        emit(VideoInfoError('Failed to load doer'));
        return;
      }

      final exercise = await _fetchExercise(challenge.exerciseId);

      if (exercise == null) {
        emit(VideoInfoError('Failed to load exercise'));
        return;
      }

      emit(VideoInfoLoaded(
        data: VideoInfoData(
          submission: submission,
          challenge: challenge,
          group: group,
          challenger: challenger,
          exercise: exercise,
          doer: doer,
        ),
      ));
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

  Future<UserEntity?> _fetchUser(String userId) async {
    final author = await sl<GetUserUseCase>().call(params: userId);
    UserEntity? userEntity;
    author.fold((error) {
      emit(VideoInfoError(error));
    }, (data) {
      if (data == null) {
        emit(VideoInfoError('Author not found'));
        return;
      }
      userEntity = data;
    });
    return userEntity;
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
