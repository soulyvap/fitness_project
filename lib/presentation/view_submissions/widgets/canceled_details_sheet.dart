import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/presentation/challenge/pages/challenge_page.dart';
import 'package:flutter/material.dart';

class CanceledDetailsSheet extends StatelessWidget {
  final SubmissionEntity submission;
  final String? challengeId;
  final bool showReattemptButton;
  const CanceledDetailsSheet(
      {super.key,
      required this.submission,
      this.showReattemptButton = false,
      this.challengeId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Submission canceled",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("Reason given"),
            subtitle: Text(submission.cancellationReason ?? "No reason given"),
          ),
          if (showReattemptButton)
            ElevatedButton(
              onPressed: () {
                if (challengeId != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ChallengePage(challengeId: challengeId!)));
                }
              },
              child: const Text("Post another attempt"),
            ),
        ],
      ),
    );
  }
}
