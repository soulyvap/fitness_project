import 'package:fitness_project/domain/entities/db/score.dart';
import 'package:fitness_project/domain/usecases/db/get_scores_by_submission.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ScoreSummaryState {}

class ScoreSummaryInitial extends ScoreSummaryState {}

class ScoreSummaryLoading extends ScoreSummaryState {}

class ScoreSummaryLoaded extends ScoreSummaryState {
  final List<ScoreEntity> scores;
  ScoreSummaryLoaded(this.scores);
}

class ScoreSummaryError extends ScoreSummaryState {
  final String errorMessage;
  ScoreSummaryError(this.errorMessage);
}

class ScoreSummaryCubit extends Cubit<ScoreSummaryState> {
  final String submissionId;
  final bool loadOnInit;
  final bool includeChallengeCreation;
  ScoreSummaryCubit(
      {required this.submissionId,
      this.loadOnInit = false,
      this.includeChallengeCreation = false})
      : super(ScoreSummaryInitial()) {
    if (loadOnInit) {
      loadScores();
    }
  }

  void loadScores() async {
    emit(ScoreSummaryLoading());
    try {
      final scores =
          await sl<GetScoresBySubmissionUseCase>().call(params: submissionId);
      scores.fold(
        (l) => emit(ScoreSummaryError(l.toString())),
        (r) {
          var returnScores = r as List<ScoreEntity>;
          if (includeChallengeCreation) {
            final challengeCreationScore = ScoreEntity(
                scoreId: '',
                challengeId: '',
                points: ScoreType.challengeCreation.value,
                userId: '',
                submissionId: '',
                type: ScoreType.challengeCreation,
                groupId: '');
            returnScores = [challengeCreationScore, ...returnScores];
          }
          emit(ScoreSummaryLoaded(returnScores));
        },
      );
    } catch (e) {
      emit(ScoreSummaryError(e.toString()));
    }
  }
}
