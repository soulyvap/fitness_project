import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/data/models/db/get_submission_by_challenge_and_user_req.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/usecases/db/get_challenge_by_id.dart';
import 'package:fitness_project/domain/usecases/db/get_exercise_by_id.dart';
import 'package:fitness_project/domain/usecases/db/get_group_by_id.dart';
import 'package:fitness_project/domain/usecases/db/get_submission_by_challenge_and_user.dart';
import 'package:fitness_project/domain/usecases/db/get_user.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChallengeDetailsState {}

class ChallengeDetailsLoading extends ChallengeDetailsState {}

class ChallengeDetailsLoaded extends ChallengeDetailsState {
  final ChallengeEntity challenge;
  final GroupEntity group;
  final UserEntity author;
  final ExerciseEntity exercise;
  final SubmissionEntity? submission;
  ChallengeDetailsLoaded(
      this.challenge, this.group, this.author, this.exercise, this.submission);
}

class ChallengeDetailsError extends ChallengeDetailsState {
  final String errorMessage;
  ChallengeDetailsError(this.errorMessage);
}

class ChallengeDetailsCubit extends Cubit<ChallengeDetailsState> {
  final String challengeId;
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  ChallengeDetailsCubit({required this.challengeId})
      : super(ChallengeDetailsLoading()) {
    loadData();
  }

  Future<void> loadData() async {
    try {
      final challenge = await _fetchChallenge(challengeId);

      if (challenge == null) {
        emit(ChallengeDetailsError('Failed to load challenges'));
        return;
      }
      final group = await _fetchGroup(challenge.groupId);

      if (group == null) {
        emit(ChallengeDetailsError('Failed to load group'));
        return;
      }
      final author = await _fetchAuthor(challenge.userId);

      if (author == null) {
        emit(ChallengeDetailsError('Failed to load author'));
        return;
      }
      final exercise = await _fetchExercise(challenge.exerciseId);

      if (exercise == null) {
        emit(ChallengeDetailsError('Failed to load exercise'));
        return;
      }
      final isCompleted = challenge.completedBy.contains(currentUserId);

      if (isCompleted) {
        final submission = await _fetchSubmission();
        emit(ChallengeDetailsLoaded(
            challenge, group, author, exercise, submission));
        return;
      }
      emit(ChallengeDetailsLoaded(challenge, group, author, exercise, null));
    } catch (e) {
      emit(ChallengeDetailsError(e.toString()));
    }
  }

  Future<ChallengeEntity?> _fetchChallenge(String challengeId) async {
    final challenge =
        await sl<GetChallengeByIdUseCase>().call(params: challengeId);
    ChallengeEntity? challengeEntity;
    challenge.fold((error) {
      emit(ChallengeDetailsError(error));
    }, (data) {
      if (data == null) {
        emit(ChallengeDetailsError('Challenge not found'));
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
      emit(ChallengeDetailsError(error));
    }, (data) {
      if (data == null) {
        emit(ChallengeDetailsError('Group not found'));
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
      emit(ChallengeDetailsError(error));
    }, (data) {
      if (data == null) {
        emit(ChallengeDetailsError('Author not found'));
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
      emit(ChallengeDetailsError(error));
    }, (data) {
      if (data == null) {
        emit(ChallengeDetailsError('Exercise not found'));
        return;
      }
      exerciseEntity = data;
    });
    return exerciseEntity;
  }

  Future<SubmissionEntity?> _fetchSubmission() async {
    if (currentUserId == null) {
      emit(ChallengeDetailsError('User not found'));
      return null;
    }
    final submission = await sl<GetSubmissionByChallengeAndUserUserCase>().call(
        params: GetSubmissionByChallengeAndUserReq(
            challengeId: challengeId, userId: currentUserId!));
    SubmissionEntity? submissionEntity;

    submission.fold((error) {
      emit(ChallengeDetailsError(error));
      submissionEntity = null;
    }, (data) {
      if (data == null) {
        emit(ChallengeDetailsError('Submission not found'));
        submissionEntity = null;
      }
      submissionEntity = data;
    });
    return submissionEntity;
  }
}
