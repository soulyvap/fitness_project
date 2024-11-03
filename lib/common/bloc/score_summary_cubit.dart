import 'package:fitness_project/data/models/db/get_scores_by_challenge_and_user_req.dart';
import 'package:fitness_project/domain/entities/db/score.dart';
import 'package:fitness_project/domain/usecases/db/get_scores_by_challenge_and_user.dart';
import 'package:fitness_project/service_locator.dart';
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
  final String challengeId;
  final String userId;
  final bool loadOnInit;
  ScoreSummaryCubit({
    required this.challengeId,
    required this.userId,
    this.loadOnInit = false,
  }) : super(ScoreSummaryInitial()) {
    if (loadOnInit) {
      loadScores();
    }
  }

  void loadScores() async {
    emit(ScoreSummaryLoading());
    try {
      final scores = await sl<GetScoresByChallengeAndUserUseCase>().call(
          params: GetScoresByChallengeAndUserReq(
              challengeId: challengeId, userId: userId));
      scores.fold(
        (l) => emit(ScoreSummaryError(l.toString())),
        (r) {
          var returnScores = r as List<ScoreEntity>;
          emit(ScoreSummaryLoaded(returnScores));
        },
      );
    } catch (e) {
      emit(ScoreSummaryError(e.toString()));
    }
  }
}
