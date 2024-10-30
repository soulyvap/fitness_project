import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/bloc/previous_page_cubit.dart';
import 'package:fitness_project/common/bloc/user_cubit.dart';
import 'package:fitness_project/data/db/models/add_submission_seen_req.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/domain/usecases/db/add_submission_seen.dart';
import 'package:fitness_project/presentation/navigation/pages/navigation.dart';
import 'package:fitness_project/presentation/submissions/bloc/video_info_cubit.dart';
import 'package:fitness_project/presentation/submissions/widgets/submission_info.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class VerticalVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final SubmissionEntity submission;
  final VideoInfoData? data;
  final Function(VideoInfoData)? onLoadInfo;

  const VerticalVideoPlayer({
    super.key,
    required this.controller,
    required this.submission,
    this.data,
    this.onLoadInfo,
  });

  @override
  State<VerticalVideoPlayer> createState() => _VerticalVideoPlayerState();
}

class _VerticalVideoPlayerState extends State<VerticalVideoPlayer> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    _controller = widget.controller;
    super.initState();
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      return;
    }
    final submissionSeen = widget.submission.seenBy.contains(currentUserId);
    if (!submissionSeen) {
      sl<AddSubmissionSeenUseCase>().call(
          params: AddSubmissionSeenReq(
              submissionId: widget.submission.submissionId,
              userId: currentUserId));
    }
  }

  void onBack(BuildContext context) {
    final previousPage = context.read<PreviousPageCubit>().state.previousPage;
    final fallbackPage = context.read<PreviousPageCubit>().state.fallbackPage;
    if (previousPage == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Navigation()));
    } else {
      context.read<PreviousPageCubit>().setPreviousPage(fallbackPage);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => previousPage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoInfoCubit>(
      create: (context) =>
          VideoInfoCubit(submission: widget.submission, data: widget.data),
      child: Material(
        color: Colors.black,
        child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: double.infinity,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    _controller.value.isInitialized
                        ? Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (_controller.value.isPlaying) {
                                      _controller.pause();
                                    } else {
                                      _controller.play();
                                    }
                                  });
                                },
                                child: AspectRatio(
                                  aspectRatio: 9 / 16,
                                  child: VideoPlayer(_controller),
                                ),
                              ),
                              VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                padding: const EdgeInsets.all(0),
                              )
                            ],
                          )
                        : const AspectRatio(
                            aspectRatio: 9 / 16,
                            child: Center(child: CircularProgressIndicator())),
                    AspectRatio(
                      aspectRatio: 9 / 16,
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              color: Colors.black.withOpacity(0.3),
                              padding: const EdgeInsets.only(
                                  right: 8, bottom: 8, top: 8),
                              child: Row(
                                children: [
                                  BackButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      onBack(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              color: Colors.black.withOpacity(0.3),
                              padding: const EdgeInsets.all(16),
                              child: Builder(builder: (context) {
                                final state =
                                    context.watch<VideoInfoCubit>().state;
                                final currentUserState =
                                    context.read<UserCubit>().state;

                                if (currentUserState is! UserLoaded) {
                                  return const Center(
                                    child: Text("User not found"),
                                  );
                                } else {
                                  if (state is VideoInfoLoaded) {
                                    if (widget.onLoadInfo != null) {
                                      widget.onLoadInfo!(state.data);
                                    }
                                    return SubmissionInfo(
                                      data: state.data,
                                    );
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                }
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
