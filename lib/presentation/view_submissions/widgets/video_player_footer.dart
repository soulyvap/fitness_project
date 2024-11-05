import 'package:fitness_project/common/extensions/datetime_extension.dart';
import 'package:fitness_project/common/widgets/group_tile_small.dart';
import 'package:fitness_project/common/widgets/user_tile_small.dart';
import 'package:fitness_project/presentation/group/pages/group.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/video_info_cubit.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class VideoPlayerFooter extends StatelessWidget {
  final VideoInfoState state;
  final Function() pauseVideo;
  const VideoPlayerFooter({
    super.key,
    required this.state,
    required this.pauseVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.2),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Builder(builder: (context) {
        if (state is VideoInfoLoaded) {
          final loaded = state as VideoInfoLoaded;
          final submission = loaded.data.submission;
          final challenge = loaded.data.challenge;
          final challenger = loaded.data.challenger;
          final group = loaded.data.group;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GroupTileSmall(
                group: group,
                textColor: Colors.white,
                onTap: () {
                  pauseVideo();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GroupPage(groupId: group.groupId)));
                },
              ),
              const SizedBox(
                height: 4,
              ),
              UserTileSmall(
                  user: challenger,
                  textColor: Colors.white,
                  leadingText: "Challenged by "),
              if (challenge.extraInstructions != null)
                const SizedBox(
                  height: 4,
                ),
              if (challenge.extraInstructions != null)
                ReadMoreText(
                  '"${challenge.extraInstructions!}"',
                  trimLines: 1,
                  colorClickableText: Theme.of(context).colorScheme.primary,
                  trimMode: TrimMode.Line,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontStyle: FontStyle.italic),
                ),
              const SizedBox(
                height: 4,
              ),
              Text("Posted on ${submission.createdAt.toDateTimeString()}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  )),
            ],
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
