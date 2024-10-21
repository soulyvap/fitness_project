import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/presentation/challenge_preview/pages/challenge_preview.dart';
import 'package:fitness_project/presentation/home/widgets/active_challenge_tile.dart';
import 'package:fitness_project/presentation/home/widgets/add_challenge_tile.dart';
import 'package:fitness_project/presentation/navigation/widgets/start_a_challenge_sheet.dart';
import 'package:flutter/material.dart';

class ActiveChallenges extends StatelessWidget {
  final List<ChallengeEntity> challenges;
  final List<GroupEntity> groups;
  final List<ExerciseEntity> exercises;
  const ActiveChallenges(
      {super.key,
      required this.groups,
      required this.challenges,
      required this.exercises});

  List<ChallengeEntity> orderedChallenges(List<ChallengeEntity> challenges) {
    challenges.sort((a, b) => a.endsAt.compareTo(b.endsAt));
    return challenges;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ongoing challenges",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: challenges.length + 1,
              itemBuilder: (context, index) {
                if (index < challenges.length) {
                  final challenge = orderedChallenges(challenges)[index];
                  final exercise = exercises.firstWhere(
                      (element) => element.exerciseId == challenge.exerciseId);
                  final group = groups.firstWhere(
                      (element) => element.groupId == challenge.groupId);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ActiveChallengeTile(
                        challenge: challenge,
                        exercise: exercise,
                        group: group,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChallengePreview(
                                  challengeId: challenge.challengeId),
                            ),
                          );
                        }),
                  );
                } else {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AddChallengeTile(onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            showDragHandle: true,
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (context) => const StartAChallengeSheet());
                      }));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
