import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/widgets/user_tile_small.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/likes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeButton extends StatelessWidget {
  final Function() onTap;
  final String submissionId;
  final List<String> currentLikes;
  final Function(List<String>)? onLikesLoaded;
  const LikeButton(
      {super.key,
      required this.onTap,
      required this.submissionId,
      required this.currentLikes,
      this.onLikesLoaded});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isLiked =
        currentUserId != null && currentLikes.contains(currentUserId);
    return InkWell(
      onTap: () {
        onTap();
      },
      onLongPress: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return BlocProvider<LikesCubit>(
                create: (context) =>
                    LikesCubit(submissionId: submissionId, loadOnInit: true),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  height: 300,
                  child: BlocConsumer<LikesCubit, LikesState>(
                    listener: (context, state) {
                      if (state is LikesError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage)));
                      }
                      if (state is LikesLoaded) {
                        onLikesLoaded
                            ?.call(state.likedBy.map((e) => e.userId).toList());
                      }
                    },
                    builder: (context, state) {
                      if (state is LikesLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is LikesLoaded) {
                        final likedByUsers = state.likedBy;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Likes (${likedByUsers.length})",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: likedByUsers.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      final user = likedByUsers[index];
                                      return UserTileSmall(user: user);
                                    }))
                          ],
                        );
                      }
                      return const Center(
                        child: Text("Error loading likes"),
                      );
                    },
                  ),
                ),
              );
            });
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
            Text("${currentLikes.length}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }
}
