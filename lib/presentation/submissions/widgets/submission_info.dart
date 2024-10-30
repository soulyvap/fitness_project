import 'package:fitness_project/common/extensions/datetime_extension.dart';
import 'package:fitness_project/common/widgets/challenged_by.dart';
import 'package:fitness_project/common/widgets/group_tile_small.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:flutter/material.dart';

class SubmissionInfo extends StatelessWidget {
  final SubmissionEntity submission;
  final ChallengeEntity challenge;
  final GroupEntity group;
  final ExerciseEntity exercise;
  final UserEntity challenger;
  final UserEntity doer;
  const SubmissionInfo({
    super.key,
    required this.submission,
    required this.challenge,
    required this.challenger,
    required this.group,
    required this.exercise,
    required this.doer,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${challenge.reps} ${exercise.name}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            GroupTileSmall(group: group, textColor: Colors.white),
            const SizedBox(
              height: 4,
            ),
            ChallengedBy(user: challenger, textColor: Colors.white),
            const SizedBox(
              height: 4,
            ),
            Text("Posted on ${submission.createdAt.toDateTimeString()}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}
