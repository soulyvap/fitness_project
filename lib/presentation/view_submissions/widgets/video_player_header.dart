import 'package:fitness_project/common/widgets/user_tile_small.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/video_info_cubit.dart';
import 'package:flutter/material.dart';

class VideoPlayerHeader extends StatelessWidget {
  final VideoInfoState videoInfoState;
  const VideoPlayerHeader({super.key, required this.videoInfoState});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.2),
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: Row(
        children: [
          const BackButton(
            color: Colors.white,
          ),
          Builder(builder: (context) {
            if (videoInfoState is VideoInfoLoaded) {
              final state = videoInfoState as VideoInfoLoaded;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${state.data.challenge.reps} ${state.data.exercise.name}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  UserTileSmall(
                      user: state.data.doer,
                      textColor: Colors.white,
                      leadingText: "Posted by"),
                ],
              );
            } else {
              return const SizedBox();
            }
          }),
        ],
      ),
    );
  }
}
