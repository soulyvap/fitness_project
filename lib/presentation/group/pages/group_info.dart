import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/presentation/group/bloc/group_cubit.dart';
import 'package:fitness_project/presentation/group/widgets/group_header.dart';
import 'package:fitness_project/presentation/home/widgets/challenge_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupInfoTab extends StatelessWidget {
  final GroupEntity group;
  final Function() onTapAddChallengeExtra;
  const GroupInfoTab(
      {super.key, required this.group, required this.onTapAddChallengeExtra});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final groupState = context.watch<GroupCubit>().state;
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: GroupHeader(group: group),
            ),
            if (groupState is GroupLoaded)
              ChallengeList(
                  challenges: groupState.activeChallenges,
                  exercises: groupState.allExercises,
                  group: group,
                  onTapAddChallengeExtra: () {
                    onTapAddChallengeExtra();
                  },
                  title:
                      "Active challenges (${groupState.activeChallenges.length})"),
            if (groupState is GroupLoaded)
              ChallengeList(
                  challenges: groupState.previousChallenges,
                  exercises: groupState.allExercises,
                  group: group,
                  lastFirst: true,
                  title:
                      "Previous challenges (${groupState.activeChallenges.length})"),
          ],
        ),
      );
    });
  }
}
