import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/bloc/need_refresh_cubit.dart';
import 'package:fitness_project/data/models/db/add_submission_seen_req.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/domain/usecases/db/add_submission_seen.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/video_info_cubit.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/cancel_submission_card.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/video_player_footer.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/video_player_header.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/video_player_side_buttons.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class VerticalVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final SubmissionEntity submission;
  final VideoInfoData? data;
  final bool reviewing;
  final Function(VideoInfoData)? onLoadInfo;
  final Function(bool)? onMute;

  const VerticalVideoPlayer({
    super.key,
    required this.controller,
    required this.submission,
    this.data,
    this.onLoadInfo,
    this.reviewing = false,
    this.onMute,
  });

  @override
  State<VerticalVideoPlayer> createState() => _VerticalVideoPlayerState();
}

class _VerticalVideoPlayerState extends State<VerticalVideoPlayer> {
  late VideoPlayerController _controller;
  late bool videoIsMuted;
  @override
  void initState() {
    super.initState();
    context.read<NeedRefreshCubit>().setValue(true);
    _controller = widget.controller;
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
    videoIsMuted = _controller.value.volume == 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoInfoCubit>(
      create: (context) =>
          VideoInfoCubit(submission: widget.submission, data: widget.data),
      child: BlocConsumer<VideoInfoCubit, VideoInfoState>(
          listener: (context, state) {
        if (state is VideoInfoLoaded) {
          widget.onLoadInfo?.call(state.data);
        }
      }, builder: (context, state) {
        final isCanceled = widget.data?.submission.cancelledAt != null;
        return Material(
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
                              child:
                                  Center(child: CircularProgressIndicator())),
                      AspectRatio(
                        aspectRatio: 9 / 16,
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              VideoPlayerHeader(
                                videoInfoData: widget.data,
                                onCancelSubmission: () {
                                  context.read<VideoInfoCubit>().loadData();
                                },
                              ),
                              if (isCanceled || widget.reviewing)
                                CancelSubmissionCard(
                                  videoInfoData: widget.data,
                                  onCancel: () {
                                    context.read<VideoInfoCubit>().loadData();
                                  },
                                ),
                              const Spacer(),
                              Row(
                                children: [
                                  const Spacer(),
                                  VideoPlayerSideButtons(
                                    videoInfoData: widget.data,
                                    isMuted: videoIsMuted,
                                    onMuteChanged: (isMuted) {
                                      setState(() {
                                        videoIsMuted = isMuted;
                                      });
                                      if (isMuted) {
                                        _controller.setVolume(0);
                                      } else {
                                        _controller.setVolume(1);
                                      }
                                      widget.onMute?.call(isMuted);
                                    },
                                  ),
                                ],
                              ),
                              VideoPlayerFooter(
                                  videoInfoData: widget.data,
                                  pauseVideo: () {
                                    _controller.pause();
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
      }),
    );
  }
}
