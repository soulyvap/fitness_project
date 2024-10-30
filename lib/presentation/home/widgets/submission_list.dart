import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/presentation/home/widgets/submission_tile.dart';
import 'package:flutter/material.dart';

class SubmissionList extends StatelessWidget {
  final List<SubmissionEntity> submissions;
  final List<ChallengeEntity> challenges;
  final List<GroupEntity> groups;
  final List<ExerciseEntity> exercises;
  final String title;

  const SubmissionList({
    super.key,
    required this.submissions,
    required this.groups,
    required this.challenges,
    required this.exercises,
    required this.title,
  });

  List<SubmissionEntity> orderedSubmissions(
      List<SubmissionEntity> submissions) {
    submissions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return submissions;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 190,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final submission = orderedSubmissions(submissions)[index];
                final challenge = challenges.firstWhere(
                    (element) => element.challengeId == submission.challengeId);
                final exercise = exercises.firstWhere(
                    (element) => element.exerciseId == challenge.exerciseId);
                final group = groups.firstWhere(
                    (element) => element.groupId == challenge.groupId);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: SubmissionTile(
                      submission: submission,
                      challenge: challenge,
                      exercise: exercise,
                      group: group),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
