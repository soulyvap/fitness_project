import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/data/models/db/update_like_req.dart';
import 'package:fitness_project/domain/usecases/db/update_like.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideButtonState {
  final List<String> seenBy;
  final List<String> likedBy;
  final int comments;

  SideButtonState({
    required this.seenBy,
    required this.likedBy,
    required this.comments,
  });

  SideButtonState copyWith({
    List<String>? seenBy,
    List<String>? likedBy,
    int? comments,
  }) {
    return SideButtonState(
      seenBy: seenBy ?? this.seenBy,
      likedBy: likedBy ?? this.likedBy,
      comments: comments ?? this.comments,
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
}
