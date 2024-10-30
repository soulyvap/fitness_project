import 'package:fitness_project/common/extensions/datetime_extension.dart';
import 'package:fitness_project/common/widgets/challenged_by.dart';
import 'package:fitness_project/common/widgets/group_tile_small.dart';
import 'package:fitness_project/presentation/submissions/bloc/video_info_cubit.dart';
import 'package:flutter/material.dart';

class SubmissionInfo extends StatelessWidget {
  final VideoInfoData data;
  const SubmissionInfo({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final submission = data.submission;
    final challenge = data.challenge;
    final group = data.group;
    final exercise = data.exercise;
    final challenger = data.challenger;
    final doer = data.doer;
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
