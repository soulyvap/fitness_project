import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LikesState {}

class LikesInitial extends LikesState {}

class LikesLoading extends LikesState {}

class LikesLoaded extends LikesState {
  final List<UserEntity> likedBy;

  LikesLoaded({
    required this.likedBy,
  });
}

class LikesError extends LikesState {
  final String errorMessage;

  LikesError(this.errorMessage);
}

class LikesCubit extends Cubit<LikesState> {
  final String submissionId;
  final bool loadOnInit;
  LikesCubit({required this.submissionId, this.loadOnInit = false})
      : super(LikesInitial()) {
    if (loadOnInit) {
      loadData();
    }
  }

  Future<void> loadData() async {
    emit(LikesLoading());
    try {
      final submission = await _fetchSubmission();
      if (submission == null) {
        return;
      }
      final likedBy = await _fetchUsers(submission.likedBy);
      emit(LikesLoaded(likedBy: likedBy));
    } catch (e) {
      emit(LikesError(e.toString()));
    }
  }

  Future<SubmissionEntity?> _fetchSubmission() async {
    final submission = await sl<DBRepository>().getSubmissionById(submissionId);
    SubmissionEntity? submissionEntity;
    submission.fold(
      (l) => emit(LikesError(l.toString())),
      (r) => submissionEntity = r,
    );
    return submissionEntity;
  }

  Future<List<UserEntity>> _fetchUsers(List<String> userIds) async {
    final users = await sl<DBRepository>().getUsersByIds(userIds);
    List<UserEntity> userEntities = [];
    users.fold(
      (l) => emit(LikesError(l.toString())),
      (r) => userEntities = r,
    );
    return userEntities;
  }
}
