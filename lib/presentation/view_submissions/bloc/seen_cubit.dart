import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SeenState {}

class SeenInitial extends SeenState {}

class SeenLoading extends SeenState {}

class SeenLoaded extends SeenState {
  final List<UserEntity> seenBy;

  SeenLoaded({
    required this.seenBy,
  });
}

class SeenError extends SeenState {
  final String errorMessage;

  SeenError(this.errorMessage);
}

class SeenCubit extends Cubit<SeenState> {
  final String submissionId;
  final bool loadOnInit;
  SeenCubit({required this.submissionId, this.loadOnInit = false})
      : super(SeenInitial()) {
    if (loadOnInit) {
      loadData();
    }
  }

  Future<void> loadData() async {
    emit(SeenLoading());
    try {
      final submission = await _fetchSubmission();
      if (submission == null) {
        return;
      }
      final likedBy = await _fetchUsers(submission.likedBy);
      emit(SeenLoaded(seenBy: likedBy));
    } catch (e) {
      emit(SeenError(e.toString()));
    }
  }

  Future<SubmissionEntity?> _fetchSubmission() async {
    final submission = await sl<DBRepository>().getSubmissionById(submissionId);
    SubmissionEntity? submissionEntity;
    submission.fold(
      (l) => emit(SeenError(l.toString())),
      (r) => submissionEntity = r,
    );
    return submissionEntity;
  }

  Future<List<UserEntity>> _fetchUsers(List<String> userIds) async {
    final users = await sl<DBRepository>().getUsersByIds(userIds);
    List<UserEntity> userEntities = [];
    users.fold(
      (l) => emit(SeenError(l.toString())),
      (r) => userEntities = r,
    );
    return userEntities;
  }
}
