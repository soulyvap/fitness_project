import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/side_buttons_cubit.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/video_info_cubit.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/comment_button.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/like_button.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/seen_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoPlayerSideButtons extends StatelessWidget {
  final VideoInfoState state;
  const VideoPlayerSideButtons({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        return const Center(
          child: Text("User not found"),
        );
      }
      if (state is! VideoInfoLoaded) {
        return const SizedBox();
      } else {
        return BlocProvider<SideButtonsCubit>(
          create: (context) => SideButtonsCubit(
              submissionId:
                  (state as VideoInfoLoaded).data.submission.submissionId,
              initialState: SideButtonState(
                seenBy: (state as VideoInfoLoaded)
                        .data
                        .submission
                        .seenBy
                        .contains(currentUserId)
                    ? (state as VideoInfoLoaded).data.submission.seenBy
                    : (state as VideoInfoLoaded).data.submission.seenBy +
                        [currentUserId],
                likedBy: (state as VideoInfoLoaded).data.submission.likedBy,
                commentCount:
                    (state as VideoInfoLoaded).data.submission.commentCount,
              )),
          child: Builder(builder: (sideButtonsContext) {
            final sideButtonsState =
                sideButtonsContext.watch<SideButtonsCubit>().state;
            final likedBy = sideButtonsState.likedBy;
            final seenBy = sideButtonsState.seenBy;
            final commentCount = sideButtonsState.commentCount;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LikeButton(
                    onTap: () {
                      sideButtonsContext.read<SideButtonsCubit>().onLike();
                    },
                    submissionId:
                        (state as VideoInfoLoaded).data.submission.submissionId,
                    currentLikes: likedBy,
                    onLikesLoaded: (likes) {
                      sideButtonsContext
                          .read<SideButtonsCubit>()
                          .updateLikes(likes);
                    },
                  ),
                  CommentButton(
                      submissionId: (state as VideoInfoLoaded)
                          .data
                          .submission
                          .submissionId,
                      updateCommentCount: (count) => sideButtonsContext
                          .read<SideButtonsCubit>()
                          .updateCommentCount(count),
                      commentCount: commentCount),
                  SeenButton(
                    currentSeen: seenBy,
                    submissionId:
                        (state as VideoInfoLoaded).data.submission.submissionId,
                    onSeenLoaded: (seenBy) {
                      sideButtonsContext
                          .read<SideButtonsCubit>()
                          .updateSeenBy(seenBy);
                    },
                  ),
                ],
              ),
            );
          }),
        );
      }
    });
  }
}
