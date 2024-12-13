import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/data/models/db/update_submission_req.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/domain/usecases/db/update_submission.dart';
import 'package:fitness_project/main.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/cancel_submission_sheet.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/delete_submission_sheet.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';

class VideoPlayerHeaderMenu extends StatelessWidget {
  final ChallengeEntity challenge;
  final SubmissionEntity submission;
  final Function() onCancel;
  final Function() onDelete;
  const VideoPlayerHeaderMenu(
      {super.key,
      required this.challenge,
      required this.submission,
      required this.onCancel,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final challengeEnded = challenge.endsAt.isBefore(DateTime.now());
    final isInitiator =
        challenge.userId == FirebaseAuth.instance.currentUser?.uid;
    final isCancelled = submission.cancelledAt != null;
    final isOwnSubmission =
        submission.userId == FirebaseAuth.instance.currentUser?.uid;
    final showDelete = !challengeEnded && isOwnSubmission;
    final showCancel = isInitiator && !isCancelled && !isOwnSubmission;
    if (!showDelete && !showCancel) {
      return const SizedBox();
    }
    return IconButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showDelete)
                          ListTile(
                            leading: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            title: const Text("Delete your submission"),
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return DeleteSubmissionSheet(
                                        submissionId: submission.submissionId,
                                        challengeId: challenge.challengeId,
                                        onDelete: onDelete);
                                  });
                            },
                          ),
                        if (showCancel)
                          ListTile(
                            leading: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            title: const Text("Cancel submission"),
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return CancelSubmissionSheet(
                                      onCancel: (reason) async {
                                        final req = UpdateSubmissionReq(
                                            submissionId:
                                                submission.submissionId,
                                            cancellationReason: reason,
                                            cancelledAt: Timestamp.now(),
                                            cancelledBy: FirebaseAuth
                                                .instance.currentUser?.uid);
                                        await sl<UpdateSubmissionUseCase>()
                                            .call(params: req);
                                        onCancel();
                                        navigatorKey.currentState?.pop();
                                      },
                                    );
                                  });
                            },
                          ),
                      ],
                    ),
                  ),
                );
              });
        },
        icon: const Icon(Icons.more_vert, color: Colors.white));
  }
}
