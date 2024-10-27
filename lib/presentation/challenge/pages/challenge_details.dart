import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/bloc/score_summary_cubit.dart';
import 'package:fitness_project/common/extensions/int_extension.dart';
import 'package:fitness_project/common/widgets/score_summary.dart';
import 'package:fitness_project/domain/entities/db/score.dart';
import 'package:fitness_project/presentation/challenge/bloc/challenge_details_cubit.dart';
import 'package:fitness_project/common/widgets/countdown.dart';
import 'package:fitness_project/presentation/challenge/widgets/challenge_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeDetails extends StatelessWidget {
  final String challengeId;
  final bool? showPoints;
  const ChallengeDetails(
      {super.key, required this.challengeId, this.showPoints});

  void _showPoints(BuildContext context, List<ScoreEntity> scores) {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (context) {
          return ScoreSummary(scores: scores);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge details'),
      ),
      body: BlocProvider<ChallengeDetailsCubit>(
        create: (context) => ChallengeDetailsCubit(challengeId: challengeId),
        child: BlocBuilder<ChallengeDetailsCubit, ChallengeDetailsState>(
          builder: (context, state) {
            if (state is ChallengeDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChallengeDetailsLoaded) {
              final challenge = state.challenge;
              final author = state.author;
              final group = state.group;
              final exercise = state.exercise;
              final isAuthor =
                  challenge.userId == FirebaseAuth.instance.currentUser?.uid;
              final isCompleted = challenge.completedBy
                  .contains(FirebaseAuth.instance.currentUser?.uid);
              final completedBy = challenge.completedBy;
              final completedByWithoutAuthor =
                  completedBy.where((id) => id != challenge.userId).toList();
              final potentialPlacement = completedByWithoutAuthor.length + 1;
              final actualPlacement = isCompleted &&
                      !isAuthor &&
                      FirebaseAuth.instance.currentUser != null
                  ? completedByWithoutAuthor
                          .indexOf(FirebaseAuth.instance.currentUser!.uid) +
                      1
                  : null;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Countdown(
                              secondsLeft: challenge.endsAt
                                  .difference(DateTime.now())
                                  .inSeconds),
                          if (!isAuthor &&
                              !isCompleted &&
                              potentialPlacement <= 5)
                            Text(
                                "Be the ${potentialPlacement.toOrdinal()} to complete!\nGet ${ScoreType.earlyParticipation(potentialPlacement)?.value} extra points!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          if (isCompleted)
                            Text(
                                "You have completed this challenge!${!isAuthor ? '\nYou placed ${actualPlacement?.toOrdinal()})!' : ''}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          if (isCompleted && state.submission != null)
                            BlocProvider<ScoreSummaryCubit>(
                              create: (context) => ScoreSummaryCubit(
                                  submissionId: state.submission!.submissionId,
                                  loadOnInit: showPoints == true,
                                  includeChallengeCreation: isAuthor),
                              child: BlocConsumer<ScoreSummaryCubit,
                                  ScoreSummaryState>(
                                listener: (context, scoreState) {
                                  if (scoreState is ScoreSummaryError) {
                                    debugPrint(scoreState.errorMessage);
                                  }
                                  if (scoreState is ScoreSummaryLoaded) {
                                    _showPoints(context, scoreState.scores);
                                  }
                                },
                                builder: (context, scoreState) {
                                  return OutlinedButton(
                                      onPressed: () {
                                        if (scoreState is ScoreSummaryLoaded) {
                                          _showPoints(
                                              context, scoreState.scores);
                                        } else {
                                          context
                                              .read<ScoreSummaryCubit>()
                                              .loadScores();
                                        }
                                      },
                                      child: const Text('View points earned'));
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  ChallengeCard(
                      challenge: challenge,
                      author: author,
                      group: group,
                      exercise: exercise),
                ]),
              );
            } else if (state is ChallengeDetailsError) {
              return Center(child: Text(state.errorMessage));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}
