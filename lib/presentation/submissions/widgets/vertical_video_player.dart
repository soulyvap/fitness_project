import 'package:fitness_project/common/bloc/user_cubit.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/presentation/post_submission/widgets/challenge_short_info.dart';
import 'package:fitness_project/presentation/submissions/bloc/video_info_cubit.dart';
import 'package:fitness_project/presentation/submissions/widgets/submission_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class VerticalVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final SubmissionEntity submission;

  const VerticalVideoPlayer({
    super.key,
    required this.controller,
    required this.submission,
  });

  @override
  State<VerticalVideoPlayer> createState() => _VerticalVideoPlayerState();
}

class _VerticalVideoPlayerState extends State<VerticalVideoPlayer> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    setState(() {});
    _controller.setLooping(true);
    _controller.seekTo(Duration.zero);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoInfoCubit>(
      create: (context) => VideoInfoCubit(submission: widget.submission),
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
                              child: const Row(
                                children: [
                                  BackButton(
                                    color: Colors.white,
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
                                    return SubmissionInfo(
                                      challenge: state.challenge,
                                      exercise: state.exercise,
                                      group: state.group,
                                      challenger: state.challenger,
                                      submission: widget.submission,
                                      doer: currentUserState.user,
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
