import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/bloc/user_cubit.dart';
import 'package:fitness_project/common/extensions/datetime_extension.dart';
import 'package:fitness_project/common/widgets/group_tile_small.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmissionTile extends StatelessWidget {
  final SubmissionEntity submission;
  final ChallengeEntity challenge;
  final ExerciseEntity exercise;
  final GroupEntity? group;
  final Function()? onTap;
  final double width;

  const SubmissionTile(
      {super.key,
      required this.submission,
      required this.challenge,
      required this.exercise,
      this.group,
      this.onTap,
      this.width = 100});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserCubit>(
      create: (context) => UserCubit(),
      child: BlocConsumer<UserCubit, UserState>(listener: (context, state) {
        if (state is UserInitial) {
          context.read<UserCubit>().loadUser(submission.userId);
        }
      }, builder: (context, userState) {
        final currentUserId = FirebaseAuth.instance.currentUser?.uid;
        final seenByCurrentUser = submission.seenBy.contains(currentUserId);
        final isCancelled = submission.cancelledAt != null;
        return InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SizedBox(
                      width: width,
                      child: AspectRatio(
                        aspectRatio: 10 / 16,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(submission.thumbnailUrl),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(
                                        seenByCurrentUser ? 0.7 : 0.2),
                                    BlendMode.darken)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(submission.createdAt.toTimeAgo(),
                                      maxLines: 2,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black,
                                              offset: Offset(1, 1),
                                              blurRadius: 2,
                                            )
                                          ])),
                                  if (seenByCurrentUser)
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                        SizedBox(width: 4),
                                        Text("seen",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black,
                                                    offset: Offset(1, 1),
                                                    blurRadius: 2,
                                                  )
                                                ])),
                                      ],
                                    ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(challenge.title,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black,
                                              offset: Offset(1, 1),
                                              blurRadius: 2,
                                            )
                                          ])),
                                  Text(
                                      userState is UserLoaded
                                          ? userState.user.displayName
                                          : "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black,
                                              offset: Offset(1, 1),
                                              blurRadius: 2,
                                            )
                                          ])),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isCancelled)
                    Card(
                      color: Colors.red.withOpacity(0.7),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          "Cancelled",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (group != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GroupTileSmall(group: group!),
                ),
            ],
          ),
        );
      }),
    );
  }
}
