import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/presentation/group/bloc/group_cubit.dart';
import 'package:fitness_project/presentation/group/bloc/group_submissions_cubit.dart';
import 'package:fitness_project/presentation/home/widgets/submission_tile.dart';
import 'package:fitness_project/presentation/view_submissions/pages/video_scroller.dart';
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
    final isMember = FirebaseAuth.instance.currentUser?.uid != null &&
        group.members.contains(FirebaseAuth.instance.currentUser!.uid);
    if (!isMember) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.group,
              size: 48,
              color: Colors.grey,
            ),
            Text('Join the group to view submissions'),
          ],
        ),
      );
    }
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
              Future.delayed(const Duration(seconds: 1));
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
                  onTap: () {
                    if (!isMember) {
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => VideoScroller(
                                submissions: submissions,
                                startIndex: index,
                              )),
                    );
                  },
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
