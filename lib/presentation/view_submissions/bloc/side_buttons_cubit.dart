import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/data/models/db/update_like_req.dart';
import 'package:fitness_project/domain/usecases/db/update_like.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideButtonState {
  final List<String> seenBy;
  final List<String> likedBy;
  final int commentCount;

  SideButtonState({
    required this.seenBy,
    required this.likedBy,
    required this.commentCount,
  });

  SideButtonState copyWith({
    List<String>? seenBy,
    List<String>? likedBy,
    int? commentCount,
  }) {
    return SideButtonState(
      seenBy: seenBy ?? this.seenBy,
      likedBy: likedBy ?? this.likedBy,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}

class SideButtonsCubit extends Cubit<SideButtonState> {
  final String submissionId;
  final SideButtonState initialState;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  SideButtonsCubit({required this.submissionId, required this.initialState})
      : super(initialState);

  void onLike() async {
    if (currentUserId == null) return;
    final likedBy = state.likedBy;
    final isCurrentlyLiked = likedBy.contains(currentUserId);
    List<String> newLikedBy = [];
    if (isCurrentlyLiked) {
      newLikedBy =
          likedBy.where((element) => element != currentUserId).toList();
    } else {
      newLikedBy = [...likedBy, currentUserId!];
    }
    emit(state.copyWith(likedBy: newLikedBy));
    await sl<UpdateLikeUseCase>().call(
        params: UpdateLikeReq(
            submissionId: submissionId,
            userId: currentUserId!,
            isLiked: !isCurrentlyLiked));
  }

  void updateCommentCount(int newCommentCount) {
    emit(state.copyWith(commentCount: newCommentCount));
  }

  void updateLikes(List<String> newLikes) {
    emit(state.copyWith(likedBy: newLikes));
  }

  void updateSeenBy(List<String> newSeenBy) {
    emit(state.copyWith(seenBy: newSeenBy));
  }
}
