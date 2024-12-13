import 'package:fitness_project/common/bloc/need_refresh_cubit.dart';
import 'package:fitness_project/common/widgets/user_tile_small.dart';
import 'package:fitness_project/presentation/challenge/pages/challenge_page.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/video_info_cubit.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/video_player_header_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoPlayerHeader extends StatelessWidget {
  final VideoInfoData? videoInfoData;
  final Function() onCancelSubmission;
  const VideoPlayerHeader(
      {super.key,
      required this.videoInfoData,
      required this.onCancelSubmission});

  @override
  Widget build(BuildContext context) {
    void setNeedRefresh() {
      context.read<NeedRefreshCubit>().setValue(true);
    }

    return Column(
      children: [
        Container(
          color: Colors.black.withOpacity(0.2),
          padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
          child: Row(
            children: [
              const BackButton(
                color: Colors.white,
              ),
              Expanded(
                child: Builder(builder: (playerContext) {
                  if (videoInfoData != null) {
                    final data = videoInfoData!;
                    final hasEnded =
                        data.challenge.endsAt.isBefore(DateTime.now());
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(playerContext).push(
                                    MaterialPageRoute(
                                        builder: (context) => ChallengePage(
                                            challengeId:
                                                data.challenge.challengeId)));
                              },
                              child: Text(
                                  "${data.challenge.reps} ${data.exercise.name}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )),
                            ),
                            UserTileSmall(
                                user: data.doer,
                                textColor: Colors.white,
                                leadingText: "Posted by"),
                          ],
                        ),
                        VideoPlayerHeaderMenu(
                            challenge: data.challenge,
                            submission: data.submission,
                            onCancel: () {
                              onCancelSubmission();
                            },
                            onDelete: setNeedRefresh),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
