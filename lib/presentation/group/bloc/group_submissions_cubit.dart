import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/domain/usecases/db/get_submissions_by_groups.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class GroupSubmissionsState {}

class GroupSubmissionsInitial extends GroupSubmissionsState {}

class GroupSubmissionsLoading extends GroupSubmissionsState {}

class GroupSubmissionsLoaded extends GroupSubmissionsState {
  final List<SubmissionEntity> submissions;

  GroupSubmissionsLoaded(this.submissions);
}

class GroupSubmissionsError extends GroupSubmissionsState {
  final String errorMessage;

  GroupSubmissionsError(this.errorMessage);
}

class GroupSubmissionsCubit extends Cubit<GroupSubmissionsState> {
  final String groupId;
  final bool loadOnInit;
  GroupSubmissionsCubit({required this.groupId, this.loadOnInit = false})
      : super(GroupSubmissionsInitial()) {
    if (loadOnInit) {
      loadData();
    }
  }

  Future<void> loadData() async {
    emit(GroupSubmissionsLoading());
    final submissions = await _fetchSubmissions();

    if (submissions == null) {
      emit(GroupSubmissionsError('Failed to load submissions'));
      return;
    }

    emit(GroupSubmissionsLoaded(submissions));
  }

  Future<List<SubmissionEntity>?> _fetchSubmissions() async {
    final submissions =
        await sl<GetSubmissionsByGroupsUseCase>().call(params: [groupId]);
    List<SubmissionEntity>? submissionsList;

    submissions.fold(
      (failure) {
        emit(GroupSubmissionsError(failure.message));
      },
      (submissions) {
        submissionsList = submissions;
      },
    );

    return submissionsList;
  }
}
