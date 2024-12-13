import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/side_buttons_cubit.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/video_info_cubit.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/comment_button.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/like_button.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/seen_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoPlayerSideButtons extends StatelessWidget {
  final VideoInfoData? videoInfoData;
  final bool isMuted;
  final Function(bool) onMuteChanged;
  const VideoPlayerSideButtons(
      {super.key,
      required this.videoInfoData,
      this.isMuted = false,
      required this.onMuteChanged});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        return const Center(
          child: Text("User not found"),
        );
      }
      if (videoInfoData == null) {
        return const SizedBox();
      } else {
        final data = videoInfoData!;
        return BlocProvider<SideButtonsCubit>(
          create: (context) => SideButtonsCubit(
              submissionId: data.submission.submissionId,
              initialState: SideButtonState(
                seenBy: data.submission.seenBy.contains(currentUserId)
                    ? data.submission.seenBy
                    : data.submission.seenBy + [currentUserId],
                likedBy: data.submission.likedBy,
                commentCount: data.submission.commentCount,
              )),
          child: Builder(builder: (sideButtonsContext) {
            final sideButtonsState =
                sideButtonsContext.watch<SideButtonsCubit>().state;
            final likedBy = sideButtonsState.likedBy;
            final seenBy = sideButtonsState.seenBy;
            final commentCount = sideButtonsState.commentCount;

            return Card(
              elevation: 0,
              color: Colors.black.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LikeButton(
                      onTap: () {
                        sideButtonsContext.read<SideButtonsCubit>().onLike();
                      },
                      submissionId: data.submission.submissionId,
                      currentLikes: likedBy,
                      onLikesLoaded: (likes) {
                        sideButtonsContext
                            .read<SideButtonsCubit>()
                            .updateLikes(likes);
                      },
                    ),
                    CommentButton(
                        submissionId: data.submission.submissionId,
                        updateCommentCount: (count) => sideButtonsContext
                            .read<SideButtonsCubit>()
                            .updateCommentCount(count),
                        commentCount: commentCount),
                    SeenButton(
                      currentSeen: seenBy,
                      submissionId: data.submission.submissionId,
                      onSeenLoaded: (seenBy) {
                        sideButtonsContext
                            .read<SideButtonsCubit>()
                            .updateSeenBy(seenBy);
                      },
                    ),
                    InkWell(
                      onTap: () {
                        onMuteChanged(!isMuted);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(isMuted ? Icons.volume_off : Icons.volume_up,
                                size: 32,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    color: Colors.white,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  )
                                ]),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        );
      }
    });
  }
}
