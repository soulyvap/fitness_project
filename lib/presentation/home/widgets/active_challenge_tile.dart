import 'dart:async';

import 'package:fitness_project/common/extensions/int_extension.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:flutter/material.dart';

class ActiveChallengeTile extends StatefulWidget {
  final ChallengeEntity challenge;
  final ExerciseEntity exercise;
  final GroupEntity group;
  final Function()? onTap;

  const ActiveChallengeTile(
      {super.key,
      required this.challenge,
      required this.exercise,
      required this.group,
      this.onTap});

  @override
  State<ActiveChallengeTile> createState() => _ActiveChallengeTileState();
}

class _ActiveChallengeTileState extends State<ActiveChallengeTile> {
  int? secondsLeft;

  void _startCountdown(DateTime challengeEndTime) {
    if (secondsLeft == null) {
      return;
    }
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft! <= 0) {
        timer.cancel();
        return;
      }
      setState(() {
        secondsLeft = secondsLeft! - 1;
      });
    });
  }

  @override
  void initState() {
    secondsLeft = widget.challenge.endsAt.difference(DateTime.now()).inSeconds;
    _startCountdown(widget.challenge.endsAt);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Column(
        children: [
          Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              height: 120,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: widget.exercise.imageUrl == null
                        ? null
                        : DecorationImage(
                            image: NetworkImage(widget.exercise.imageUrl!),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.darken)),
                  ),
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.hourglass_bottom_rounded,
                                  size: 14),
                              Text(
                                "${secondsLeft?.secondsToTimeString()}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "${widget.challenge.reps}",
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.exercise.name,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
              width: 110,
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                      image: widget.group.imageUrl == null
                          ? null
                          : DecorationImage(
                              image: NetworkImage(widget.group.imageUrl!),
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: widget.group.imageUrl == null
                        ? const Icon(Icons.group)
                        : null,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.group.name,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
