import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/data/models/db/update_submission_req.dart';
import 'package:fitness_project/domain/usecases/db/update_submission.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/video_info_cubit.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/cancel_submission_sheet.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/canceled_details_sheet.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';

class CancelSubmissionCard extends StatelessWidget {
  final VideoInfoData? videoInfoData;
  final Function() onCancel;
  const CancelSubmissionCard({
    super.key,
    required this.videoInfoData,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (videoInfoData != null) {
        final data = videoInfoData!;
        final isCanceled = data.submission.cancelledAt != null;
        final isAuthor =
            data.submission.userId == FirebaseAuth.instance.currentUser?.uid;
        final showReattemptButton =
            data.challenge.endsAt.isAfter(DateTime.now()) &&
                isCanceled &&
                isAuthor;
        return Card(
          color: Colors.white.withOpacity(0.8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isCanceled
                      ? "Submission canceled"
                      : "This submission is not valid?",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            if (isCanceled) {
                              return CanceledDetailsSheet(
                                submission: data.submission,
                                challengeId: data.challenge.challengeId,
                                showReattemptButton: showReattemptButton,
                              );
                            } else {
                              return CancelSubmissionSheet(
                                onCancel: (reason) async {
                                  final req = UpdateSubmissionReq(
                                      submissionId:
                                          data.submission.submissionId,
                                      cancellationReason: reason,
                                      cancelledAt: Timestamp.now(),
                                      cancelledBy: FirebaseAuth
                                          .instance.currentUser?.uid);
                                  await sl<UpdateSubmissionUseCase>()
                                      .call(params: req);
                                  onCancel();
                                },
                              );
                            }
                          });
                    },
                    child: Text(isCanceled ? "View details" : "Cancel it")),
              ],
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
