import 'package:fitness_project/presentation/post_submission/bloc/challenge_preview_cubit.dart';
import 'package:fitness_project/common/widgets/countdown.dart';
import 'package:fitness_project/presentation/post_submission/widgets/challenge_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengePreview extends StatelessWidget {
  final String challengeId;
  const ChallengePreview({super.key, required this.challengeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge preview'),
      ),
      body: BlocProvider<ChallengePreviewCubit>(
        create: (context) => ChallengePreviewCubit(challengeId: challengeId),
        child: BlocBuilder<ChallengePreviewCubit, ChallengePreviewState>(
          builder: (context, state) {
            if (state is Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is Loaded) {
              final challenge = state.challenge;
              final author = state.author;
              final group = state.group;
              final exercise = state.exercise;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Expanded(
                    child: Center(
                      child: Countdown(
                          secondsLeft: challenge.endsAt
                              .difference(DateTime.now())
                              .inSeconds),
                    ),
                  ),
                  ChallengeCard(
                      challenge: challenge,
                      author: author,
                      group: group,
                      exercise: exercise),
                ]),
              );
            } else if (state is Error) {
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
