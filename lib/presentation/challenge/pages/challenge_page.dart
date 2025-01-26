import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/bloc/need_refresh_cubit.dart';
import 'package:fitness_project/common/bloc/score_summary_cubit.dart';
import 'package:fitness_project/common/extensions/int_extension.dart';
import 'package:fitness_project/common/widgets/challenge_explanation.dart';
import 'package:fitness_project/common/widgets/score_summary.dart';
import 'package:fitness_project/domain/entities/db/score.dart';
import 'package:fitness_project/presentation/challenge/bloc/challenge_details_cubit.dart';
import 'package:fitness_project/common/widgets/countdown.dart';
import 'package:fitness_project/presentation/challenge/widgets/challenge_card.dart';
import 'package:fitness_project/presentation/group/pages/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengePage extends StatefulWidget {
  final String challengeId;
  final bool? showPoints;
  final Widget? previousPage;
  const ChallengePage({
    super.key,
    required this.challengeId,
    this.previousPage,
    this.showPoints,
  });

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  void _showPoints(
      BuildContext context, List<ScoreEntity> scores, String groupId) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ScoreSummary(
            scores: scores,
            actionButton: ElevatedButton.icon(
                icon: const Icon(Icons.leaderboard),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GroupPage(
                            groupId: groupId,
                            initialTabIndex: 2,
                          )));
                },
                label: const Text("See Leaderboard")),
          );
        });
  }

  @override
  void initState() {
    context.read<NeedRefreshCubit>().setValue(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge details'),
        leading: BackButton(
          onPressed: () {
            widget.previousPage != null
                ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => widget.previousPage!))
                : Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const ChallengeExplanation();
                },
              );
            },
            icon: const Icon(Icons.help),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ChallengeDetailsCubit>().loadData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: BlocProvider<ChallengeDetailsCubit>(
            create: (context) =>
                ChallengeDetailsCubit(challengeId: widget.challengeId),
            child: BlocBuilder<ChallengeDetailsCubit, ChallengeDetailsState>(
              builder: (context, state) {
                if (state is ChallengeDetailsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChallengeDetailsLoaded) {
                  final challenge = state.challenge;
                  final author = state.author;
                  final group = state.group;
                  final exercise = state.exercise;
                  final submission = state.submission;
                  final isAuthor = challenge.userId ==
                      FirebaseAuth.instance.currentUser?.uid;
                  final isCompleted = challenge.completedBy
                      .contains(FirebaseAuth.instance.currentUser?.uid);
                  final completedBy = challenge.completedBy;
                  final completedByWithoutAuthor = completedBy
                      .where((id) => id != challenge.userId)
                      .toList();
                  final potentialPlacement =
                      completedByWithoutAuthor.length + 1;
                  final actualPlacement = isCompleted &&
                          !isAuthor &&
                          FirebaseAuth.instance.currentUser != null
                      ? completedByWithoutAuthor
                              .indexOf(FirebaseAuth.instance.currentUser!.uid) +
                          1
                      : null;
                  final isDone = challenge.endsAt.isBefore(DateTime.now());
                  final showPotentialPlacement = !isAuthor &&
                      !isCompleted &&
                      !isDone &&
                      potentialPlacement <= 5;
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Countdown(
                                secondsLeft: challenge.endsAt
                                    .difference(DateTime.now())
                                    .inSeconds),
                          ),
                          if (showPotentialPlacement)
                            Text(
                                "Be the ${potentialPlacement.toOrdinal()} to complete!\nGet ${ScoreType.earlyParticipation(potentialPlacement)?.value} extra points!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          if (isAuthor)
                            Text("You created this challenge!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          if (isCompleted)
                            Text(
                                "You have completed this challenge!${!isAuthor ? '\nYou placed ${actualPlacement?.toOrdinal()}!' : ''}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          if (isCompleted || isAuthor)
                            BlocProvider<ScoreSummaryCubit>(
                              create: (context) => ScoreSummaryCubit(
                                challengeId: widget.challengeId,
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                loadOnInit: widget.showPoints == true,
                              ),
                              child: BlocConsumer<ScoreSummaryCubit,
                                  ScoreSummaryState>(
                                listener: (context, scoreState) {
                                  if (scoreState is ScoreSummaryError) {
                                    debugPrint(scoreState.errorMessage);
                                  }
                                  if (scoreState is ScoreSummaryLoaded) {
                                    _showPoints(context, scoreState.scores,
                                        group.groupId);
                                  }
                                },
                                builder: (context, scoreState) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            visualDensity:
                                                VisualDensity.compact),
                                        onPressed: () {
                                          if (scoreState
                                              is ScoreSummaryLoaded) {
                                            _showPoints(
                                                context,
                                                scoreState.scores,
                                                group.groupId);
                                          } else {
                                            context
                                                .read<ScoreSummaryCubit>()
                                                .loadScores();
                                          }
                                        },
                                        child:
                                            const Text('View points earned')),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ChallengeCard(
                        challenge: challenge,
                        author: author,
                        group: group,
                        exercise: exercise,
                        submission: submission,
                      ),
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
        ),
      ),
    );
  }
}
