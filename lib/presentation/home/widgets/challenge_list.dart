import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/presentation/challenge/pages/challenge_page.dart';
import 'package:fitness_project/presentation/home/widgets/challenge_tile.dart';
import 'package:fitness_project/presentation/home/widgets/add_challenge_tile.dart';
import 'package:fitness_project/common/widgets/start_a_challenge_sheet.dart';
import 'package:flutter/material.dart';

class ChallengeList extends StatelessWidget {
  final List<ChallengeEntity> challenges;
  final List<GroupEntity>? groups;
  final List<ExerciseEntity> exercises;
  final String title;
  final bool lastFirst;
  final bool hideGroup;
  final GroupEntity? group;
  final Function()? onOpenModal;
  final Function()? onStartNewChallenge;

  const ChallengeList({
    super.key,
    this.groups,
    required this.challenges,
    required this.exercises,
    required this.title,
    this.hideGroup = false,
    this.lastFirst = false,
    this.group,
    this.onOpenModal,
    this.onStartNewChallenge,
  });

  List<ChallengeEntity> orderedChallenges(List<ChallengeEntity> challenges) {
    if (lastFirst) {
      challenges.sort((a, b) => b.endsAt.compareTo(a.endsAt));
    } else {
      challenges.sort((a, b) => a.endsAt.compareTo(b.endsAt));
    }
    return challenges;
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
            height: 160,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: challenges.length + 1,
              itemBuilder: (context, index) {
                if (index < challenges.length) {
                  final challenge = orderedChallenges(challenges)[index];
                  final exercise = exercises.firstWhere(
                      (element) => element.exerciseId == challenge.exerciseId);
                  final group = groups?.firstWhere(
                      (element) => element.groupId == challenge.groupId);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChallengeTile(
                        key: ValueKey(challenge.challengeId),
                        challenge: challenge,
                        exercise: exercise,
                        group: group,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChallengePage(
                                challengeId: challenge.challengeId,
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AddChallengeTile(onTap: () {
                        if (onOpenModal != null) {
                          onOpenModal!();
                        }
                        showModalBottomSheet(
                            isScrollControlled: true,
                            showDragHandle: true,
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (context) => StartAChallengeSheet(
                                  group: group,
                                  onStartChallenge: () {
                                    onStartNewChallenge?.call();
                                  },
                                ));
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
