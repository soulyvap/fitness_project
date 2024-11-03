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
      if (state is! VideoInfoLoaded) {
        return const SizedBox();
      } else {
        return BlocProvider<SideButtonsCubit>(
          create: (context) => SideButtonsCubit(
              submissionId:
                  (state as VideoInfoLoaded).data.submission.submissionId,
              initialState: SideButtonState(
                seenBy: (state as VideoInfoLoaded).data.submission.seenBy,
                likedBy: (state as VideoInfoLoaded).data.submission.likedBy,
                comments:
                    (state as VideoInfoLoaded).data.submission.commentCount,
              )),
          child: Builder(builder: (context) {
            final sideButtonsState = context.watch<SideButtonsCubit>().state;
            final likedBy = sideButtonsState.likedBy;
            final seenBy = sideButtonsState.seenBy;
            final comments = sideButtonsState.comments;
            final currentUserId = FirebaseAuth.instance.currentUser?.uid;
            final isLiked =
                currentUserId != null && likedBy.contains(currentUserId);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<SideButtonsCubit>().onLike();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.thumb_up,
                          color: isLiked
                              ? Theme.of(context).colorScheme.primary
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
                              fontSize: 12,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => const CommentModalContent());
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.comment, color: Colors.white),
                        Text("$comments",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.visibility, color: Colors.white),
                        Text("${seenBy.length}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            )),
                      ],
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
