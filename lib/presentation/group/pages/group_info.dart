import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/presentation/group/bloc/group_cubit.dart';
import 'package:fitness_project/presentation/group/widgets/group_header.dart';
import 'package:fitness_project/presentation/home/widgets/challenge_list.dart';
import 'package:flutter/material.dart';

class GroupInfoTab extends StatelessWidget {
  final GroupLoaded groupData;
  final Function(bool) setPreventReload;
  const GroupInfoTab(
      {super.key, required this.groupData, required this.setPreventReload});

  @override
  Widget build(BuildContext context) {
    final isMember = FirebaseAuth.instance.currentUser?.uid != null &&
        groupData.group.members
            .contains(FirebaseAuth.instance.currentUser!.uid);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GroupHeader(
                group: groupData.group,
                onOpenModal: () => setPreventReload(true)),
          ),
          if (isMember)
            ChallengeList(
                challenges: groupData.activeChallenges,
                exercises: groupData.allExercises,
                group: groupData.group,
                onOpenModal: () {
                  setPreventReload(true);
                },
                onStartNewChallenge: () => {
                      setPreventReload(false),
                    },
                title:
                    "Active challenges (${groupData.activeChallenges.length})"),
          if (isMember)
            ChallengeList(
                challenges: groupData.previousChallenges,
                exercises: groupData.allExercises,
                group: groupData.group,
                lastFirst: true,
                onOpenModal: () {
                  setPreventReload(true);
                },
                onStartNewChallenge: () => {
                      setPreventReload(false),
                    },
                title:
                    "Previous challenges (${groupData.activeChallenges.length})"),
          if (!isMember)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.group,
                      size: 48,
                      color: Colors.grey,
                    ),
                    Text('Join the group to view challenges'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
