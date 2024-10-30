import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/extensions/int_extension.dart';
import 'package:fitness_project/common/widgets/group_tile_small.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:flutter/material.dart';

class ChallengeTile extends StatefulWidget {
  final ChallengeEntity challenge;
  final ExerciseEntity exercise;
  final GroupEntity group;
  final Function()? onTap;

  const ChallengeTile(
      {super.key,
      required this.challenge,
      required this.exercise,
      required this.group,
      this.onTap});

  @override
  State<ChallengeTile> createState() => _ChallengeTileState();
}

class _ChallengeTileState extends State<ChallengeTile> {
  late int _secondsLeft;
  Timer? _timer;

  void _startCountdown(DateTime challengeEndTime) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        timer.cancel();
        return;
      }
      setState(() {
        _secondsLeft = _secondsLeft - 1;
      });
    });
  }

  @override
  void initState() {
    final remainingSeconds =
        widget.challenge.endsAt.difference(DateTime.now()).inSeconds;
    _secondsLeft = remainingSeconds > 0 ? remainingSeconds : 0;
    if (remainingSeconds > 0) _startCountdown(widget.challenge.endsAt);
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isCompleted = currentUserId != null &&
        widget.challenge.completedBy.contains(currentUserId);
    final completedByWithoutAuthor = widget.challenge.completedBy
        .where((id) => id != widget.challenge.userId)
        .toList();
    return InkWell(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isCompleted)
                            const Icon(Icons.check_circle,
                                color: Colors.greenAccent, size: 20),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Theme.of(context).colorScheme.secondary,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_secondsLeft > 0)
                                    const Icon(Icons.hourglass_empty_rounded,
                                        size: 14, color: Colors.white),
                                  Text(
                                    _secondsLeft > 0
                                        ? _secondsLeft.secondsToTimeString()
                                        : "Ended",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "${widget.challenge.reps}",
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.exercise.name,
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Spacer(),
                          const Icon(Icons.check_circle,
                              size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text("${completedByWithoutAuthor.length}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                              )),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GroupTileSmall(group: widget.group),
          ),
        ],
      ),
    );
  }
}
