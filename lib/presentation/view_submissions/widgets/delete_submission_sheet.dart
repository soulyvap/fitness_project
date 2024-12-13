import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/usecases/db/delete_submission.dart';
import 'package:fitness_project/domain/usecases/db/get_challenge_listener.dart';
import 'package:fitness_project/presentation/challenge/pages/challenge_page.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';

class DeleteSubmissionSheet extends StatefulWidget {
  final String submissionId;
  final String challengeId;
  final Function() onDelete;
  const DeleteSubmissionSheet(
      {super.key,
      required this.submissionId,
      required this.challengeId,
      required this.onDelete});

  @override
  State<DeleteSubmissionSheet> createState() => _DeleteSubmissionSheetState();
}

class _DeleteSubmissionSheetState extends State<DeleteSubmissionSheet> {
  bool deleting = false;
  StreamSubscription<ChallengeEntity?>? subscription;

  Future<Stream<ChallengeEntity?>?> getChallengeStream() async {
    final stream = await sl<GetChallengeListenerUseCase>()
        .call(params: widget.challengeId);
    return stream.fold(
      (l) => null,
      (r) {
        return r;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !deleting,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: deleting
            ? const AspectRatio(
                aspectRatio: 1, child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Delete your submission?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text("Your points for this submission will be lost."),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel")),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                deleting = true;
                              });
                              widget.onDelete();
                              await sl<DeleteSubmissionUseCase>()
                                  .call(params: widget.submissionId);
                              final stream = await getChallengeStream();
                              subscription = stream?.listen((challenge) {
                                if (challenge != null) {
                                  final challengeContainsCurrentUser = challenge
                                      .completedBy
                                      .contains(FirebaseAuth
                                          .instance.currentUser?.uid);
                                  if (!challengeContainsCurrentUser) {
                                    subscription?.cancel();
                                    if (context.mounted) {
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChallengePage(
                                                    challengeId:
                                                        widget.challengeId,
                                                  )));
                                    }
                                  }
                                }
                              });
                            },
                            child: const Text("Delete")),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
