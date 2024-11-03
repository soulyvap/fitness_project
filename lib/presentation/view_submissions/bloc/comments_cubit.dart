import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/data/models/db/update_comment_req.dart';
import 'package:fitness_project/domain/usecases/db/comment.dart';
import 'package:fitness_project/domain/usecases/db/get_comments_by_submission.dart';
import 'package:fitness_project/domain/usecases/db/update_comment.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CommentsState {}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<CommentEntity> comments;

  CommentsLoaded({required this.comments});
}

class CommentsError extends CommentsState {
  final String errorMessage;

  CommentsError(this.errorMessage);
}

class CommentsCubit extends Cubit<CommentsState> {
  final String submissionId;

  CommentsCubit({
    required this.submissionId,
  }) : super(CommentsInitial()) {
    loadComments();
  }

  Future<void> loadComments() async {
    emit(CommentsLoading());
    final result =
        await sl<GetCommentsBySubmissionUseCase>().call(params: submissionId);

    result.fold(
      (error) => emit(CommentsError(error.toString())),
      (comments) {
        emit(CommentsLoaded(comments: comments));
      },
    );
  }

  Future<void> addComment(String comment) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;
    final result = await sl<UpdateCommentUseCase>().call(
      params: UpdateCommentReq(
        submissionId: submissionId,
        comment: comment,
        userId: currentUserId,
      ),
    );

    result.fold(
      (error) => emit(CommentsError(error.toString())),
      (_) => loadComments(),
    );
  }
}
