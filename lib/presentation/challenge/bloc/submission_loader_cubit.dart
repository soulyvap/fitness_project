import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/domain/usecases/db/get_submissions_by_challenge.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubmissionLoaderState {}

class SubmissionLoaderInitial extends SubmissionLoaderState {}

class SubmissionLoaderLoading extends SubmissionLoaderState {}

class SubmissionLoaderLoaded extends SubmissionLoaderState {
  final List<SubmissionEntity> submissions;

  SubmissionLoaderLoaded(this.submissions);
}

class SubmissionLoaderError extends SubmissionLoaderState {
  final String message;

  SubmissionLoaderError(this.message);
}

class SubmissionLoaderCubit extends Cubit<SubmissionLoaderState> {
  final String challengeId;
  final bool loadOnInit;
  SubmissionLoaderCubit({required this.challengeId, this.loadOnInit = true})
      : super(SubmissionLoaderInitial()) {
    if (loadOnInit) {
      loadSubmissions();
    }
  }

  Future<void> loadSubmissions() async {
    emit(SubmissionLoaderLoading());
    try {
      final submissions = await sl<GetSubmissionsByChallengeUseCase>()
          .call(params: challengeId);

      submissions.fold((l) => emit(SubmissionLoaderError(l.toString())),
          (r) => emit(SubmissionLoaderLoaded(r)));
    } catch (e) {
      emit(SubmissionLoaderError(e.toString()));
    }
  }
}
