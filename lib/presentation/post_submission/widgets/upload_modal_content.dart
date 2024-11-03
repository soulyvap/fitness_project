import 'dart:io';

import 'package:fitness_project/common/bloc/user_cubit.dart';
import 'package:fitness_project/presentation/challenge/pages/challenge_page.dart';
import 'package:fitness_project/presentation/post_submission/bloc/submission_upload_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_compress/video_compress.dart';

class UploadModalContent extends StatefulWidget {
  final String challengeId;
  final File videoFile;
  final String groupId;

  const UploadModalContent({
    super.key,
    required this.challengeId,
    required this.videoFile,
    required this.groupId,
  });

  @override
  State<UploadModalContent> createState() => _UploadModalContentState();
}

class _UploadModalContentState extends State<UploadModalContent> {
  late Subscription _compressionProgressSubscription;
  double _compressionProgress = 0.0;

  @override
  void initState() {
    _compressionProgressSubscription =
        VideoCompress.compressProgress$.subscribe((progress) {
      setState(() {
        _compressionProgress = progress;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _compressionProgressSubscription.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.read<UserCubit>().state;
    final currentUser = userState is UserLoaded ? userState.user : null;
    if (currentUser == null) {
      return const Center(
        child: Text("User not found"),
      );
    }
    return BlocProvider<SubmissionUploadCubit>(
        create: (context) => SubmissionUploadCubit(
              challengeId: widget.challengeId,
              videoFile: widget.videoFile,
              groupId: widget.groupId,
            ),
        child: BlocListener<SubmissionUploadCubit, SubmissionUploadState>(
          listener: (context, state) {
            if (state is SubmissionDone) {
              Future.delayed(const Duration(seconds: 2), () {
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChallengePage(
                        challengeId: widget.challengeId,
                        showPoints: true,
                      ),
                    ),
                    (route) {
                      return route.isFirst;
                    },
                  );
                }
              });
            }
          },
          child: BlocBuilder<SubmissionUploadCubit, SubmissionUploadState>(
            builder: (context, uploadState) {
              return Container(
                height: 300,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: uploadState is! SubmissionDone
                            ? const CircularProgressIndicator()
                            : const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 80,
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text(uploadState.message,
                          style: const TextStyle(fontSize: 16)),
                      if (uploadState is CompressingVideo)
                        Text("${_compressionProgress.toStringAsFixed(0)}%")
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
