import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/side_buttons_cubit.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/video_info_cubit.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/comment_modal_content.dart';
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
            final currentUserId = FirebaseAuth.instance.currentUser?.uid;
            final isLiked =
                currentUserId != null && likedBy.contains(currentUserId);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      sideButtonsContext.read<SideButtonsCubit>().onLike();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.thumb_up,
                            size: 32,
                            color: isLiked
                                ? Theme.of(sideButtonsContext)
                                    .colorScheme
                                    .primary
                                : Colors.white,
                            shadows: const [
                              Shadow(
                                color: Colors.white,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              )
                            ],
                          ),
                          Text("${likedBy.length}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: sideButtonsContext,
                          builder: (context) => CommentModalContent(
                                submissionId: (state as VideoInfoLoaded)
                                    .data
                                    .submission
                                    .submissionId,
                                onLoadComments: (comments) => sideButtonsContext
                                    .read<SideButtonsCubit>()
                                    .updateCommentCount(comments.length),
                              ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.comment,
                              size: 32,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.white,
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                )
                              ]),
                          Text("$commentCount",
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.visibility,
                              size: 32,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.white,
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                )
                              ]),
                          Text("${seenBy.length}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
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
