import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/presentation/group/bloc/group_cubit.dart';
import 'package:fitness_project/presentation/group/bloc/group_submissions_cubit.dart';
import 'package:fitness_project/presentation/home/widgets/submission_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmissionsTab extends StatelessWidget {
  final GroupEntity group;
  final List<ChallengeEntity> challenges;
  final List<ExerciseEntity> exercises;
  const SubmissionsTab(
      {super.key,
      required this.group,
      required this.challenges,
      required this.exercises});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final submissionState = context.watch<GroupSubmissionsCubit>().state;
      if (submissionState is GroupSubmissionsInitial) {
        context.read<GroupSubmissionsCubit>().loadData();
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (submissionState is GroupSubmissionsError) {
        return Center(
          child: Text(submissionState.errorMessage),
        );
      } else if (submissionState is GroupSubmissionsLoaded) {
        final submissions = submissionState.submissions;
        return RefreshIndicator(
          onRefresh: () async {
            context.read<GroupCubit>().loadData().then((value) {
              if (context.mounted) {
                context.read<GroupSubmissionsCubit>().loadData();
              }
            });
          },
          child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: submissions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 0,
                  childAspectRatio: 10 / 16),
              itemBuilder: (context, index) {
                final submission = submissions[index];
                final challenge = challenges.firstWhere(
                    (element) => element.challengeId == submission.challengeId);
                final exercise = exercises.firstWhere(
                    (element) => element.exerciseId == challenge.exerciseId);
                return SubmissionTile(
                  submission: submission,
                  challenge: challenge,
                  exercise: exercise,
                  width: double.infinity,
                );
              }),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
