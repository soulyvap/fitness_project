import 'package:flutter_bloc/flutter_bloc.dart';

class NewChallengeFormState {
  String? groupId;
  String? exerciseId;
  int? reps;
  int? minutesToComplete;
  String? instructions;
  String? customExerciseName;

  NewChallengeFormState({
    this.groupId,
    this.exerciseId,
    this.reps,
    this.minutesToComplete,
    this.instructions,
    this.customExerciseName,
  });
}

class NewChallengeFormCubit extends Cubit<NewChallengeFormState> {
  final String? groupId;
  NewChallengeFormCubit({this.groupId})
      : super(NewChallengeFormState(groupId: groupId));

  void onValuesChanged({
    String? groupId,
    String? exerciseId,
    int? reps,
    int? minutesToComplete,
    String? instructions,
    String? customExerciseName,
  }) {
    emit(NewChallengeFormState(
      groupId: groupId ?? state.groupId,
      exerciseId: exerciseId ?? state.exerciseId,
      reps: reps ?? state.reps,
      minutesToComplete: minutesToComplete ?? state.minutesToComplete,
      instructions: instructions ?? state.instructions,
      customExerciseName: customExerciseName ?? state.customExerciseName,
    ));
  }
}
