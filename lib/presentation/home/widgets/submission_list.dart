import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/presentation/home/widgets/submission_tile.dart';
import 'package:fitness_project/presentation/view_submissions/pages/video_scroller.dart';
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
            child: Row(
              children: [
                const Icon(
                  Icons.post_add,
                  size: 32,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final ordered = orderedSubmissions(submissions);
                final submission = ordered[index];
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
                      group: group,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoScroller(
                              submissions: ordered,
                              startIndex: index,
                            ),
                          ),
                        );
                      }),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
