import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/extensions/datetime_extension.dart';
import 'package:fitness_project/common/widgets/challenge_preview_player.dart';
import 'package:fitness_project/common/widgets/challenge_preview_player_network.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/presentation/challenge/bloc/challenge_details_cubit.dart';
import 'package:fitness_project/presentation/challenge/pages/challenge_page.dart';
import 'package:fitness_project/presentation/challenge/pages/submission_loader.dart';
import 'package:fitness_project/presentation/group/pages/group.dart';
import 'package:fitness_project/presentation/post_submission/pages/camera.dart';
import 'package:fitness_project/presentation/view_submissions/pages/video_scroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class ChallengeCard extends StatelessWidget {
  final ChallengeEntity challenge;
  final GroupEntity group;
  final ExerciseEntity exercise;
  final UserEntity author;
  final SubmissionEntity? submission;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.author,
    required this.group,
    required this.exercise,
    this.submission,
  });

  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final completedBy = challenge.completedBy;
    final completedByWithoutAuthor =
        completedBy.where((e) => e != author.userId);
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    final isCompleted = completedBy.contains(currentUserUid);
    final hasEnded = challenge.endsAt.isBefore(DateTime.now());
    final isReviewable = hasEnded && challenge.userId == currentUserUid;
    final isCancelled = submission?.cancelledAt != null;
    return Card(
      child: Column(
        children: [
          ListTile(
            dense: true,
            trailing: IconButton(
                onPressed: () {
                  context.read<ChallengeDetailsCubit>().loadData();
                },
                icon: const Icon(Icons.refresh)),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              backgroundImage:
                  author.image == null ? null : NetworkImage(author.image!),
              child: author.image == null
                  ? Center(
                      child: Text(
                        author.displayName[0].toUpperCase(),
                        style: const TextStyle(fontSize: 24),
                      ),
                    )
                  : null,
            ),
            title: Text(author.displayName),
            subtitle: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroupPage(groupId: challenge.groupId),
                  ));
                },
                child: Text(group.name)),
          ),
          AspectRatio(
            aspectRatio: 1.3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: exercise.imageUrl == null
                        ? null
                        : DecorationImage(
                            image: NetworkImage(exercise.imageUrl!),
                            fit: BoxFit.contain,
                          ),
                  ),
                  child: challenge.videoUrl != null
                      ? ChallengePreviewPlayerNetwork(url: challenge.videoUrl!)
                      : exercise.imageUrl != null
                          ? null
                          : const Center(
                              child: Icon(Icons.fitness_center, size: 40)),
                ),
                if (isCompleted)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.1),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 160,
                        ),
                      ),
                    ),
                  ),
                if (isCancelled)
                  Positioned.fill(
                      child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Card(
                        color: Colors.red.withOpacity(0.7),
                        child: ListTile(
                          dense: true,
                          leading:
                              const Icon(Icons.cancel, color: Colors.white),
                          title: Text("Cancelled by ${author.displayName}:",
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(submission?.cancellationReason ?? "",
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  )),
              ],
            ),
          ),
          ListTile(
            dense: true,
            title: Text(challenge.title),
            subtitle: Text("Deadline: ${challenge.endsAt.toDateTimeString()}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 4),
                Text("${completedByWithoutAuthor.length}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(width: 8),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            width: double.infinity,
            child: challenge.extraInstructions == null
                ? null
                : Text(
                    "\"${challenge.extraInstructions}\"",
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              if (completedBy.isNotEmpty)
                OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SubmissionLoader(
                          challengeId: challenge.challengeId,
                          reviewing: isReviewable,
                        ),
                      ));
                    },
                    child: Text(
                        "${isReviewable ? "Review" : "View"} all posts (${completedBy.length})")),
              const SizedBox(width: 8),
              isCompleted
                  ? ElevatedButton(
                      onPressed: () {
                        if (submission != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                VideoScroller(submissions: [submission!]),
                          ));
                        }
                      },
                      child: const Text("Watch my post"))
                  : hasEnded
                      ? const SizedBox(
                          height: 24,
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            final challengeHasEnded =
                                challenge.endsAt.isBefore(DateTime.now());
                            if (challengeHasEnded) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "This challenge has ended. You can no longer post attempts."),
                                ),
                              );
                              Future.delayed(const Duration(seconds: 1), () {
                                if (context.mounted) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => ChallengePage(
                                            challengeId:
                                                challenge.challengeId)),
                                  );
                                }
                              });
                            }
                            await requestCameraPermission();
                            if (context.mounted) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Camera(
                                      challenge: challenge,
                                      exercise: exercise,
                                      group: group,
                                      author: author)));
                            }
                          },
                          child: Text(
                            isCancelled ? "Reattempt" : "Post an attempt",
                          )),
            ]),
          ),
        ],
      ),
    );
  }
}
