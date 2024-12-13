import 'package:fitness_project/common/widgets/user_tile_small.dart';
import 'package:fitness_project/common/widgets/group_tile_small.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:flutter/material.dart';

class ChallengeShortInfo extends StatelessWidget {
  final ChallengeEntity challenge;
  final GroupEntity group;
  final ExerciseEntity exercise;
  final UserEntity author;
  const ChallengeShortInfo({
    super.key,
    required this.challenge,
    required this.author,
    required this.group,
    required this.exercise,
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
              challenge.title,
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
            UserTileSmall(
                user: author,
                textColor: Colors.white,
                leadingText: "Challenged by "),
          ],
        ),
      ),
    );
  }
}
