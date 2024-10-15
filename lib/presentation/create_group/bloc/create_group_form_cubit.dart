import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateGroupFormState {
  String name;
  String description;
  DateTime startTime;
  DateTime endTime;
  int maxSimultaneousChallenges;
  int minutesPerChallenge;
  bool isPrivate;

  CreateGroupFormState({
    this.name = '',
    this.description = '',
    required this.startTime,
    required this.endTime,
    this.maxSimultaneousChallenges = 1,
    this.minutesPerChallenge = 1,
    this.isPrivate = false,
  });

  @override
  String toString() {
    return 'CreateGroupFormState(name: $name, description: $description, startTime: $startTime, endTime: $endTime, maxSimultaneousChallenges: $maxSimultaneousChallenges, minutesPerChallenge: $minutesPerChallenge, isPrivate: $isPrivate)';
  }
}

class CreateGroupFormCubit extends Cubit<CreateGroupFormState> {
  CreateGroupFormCubit()
      : super(CreateGroupFormState(
            startTime: DateTime.now(), endTime: DateTime.now()));

  void onValuesChanged({
    String? name,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    int? maxSimultaneousChallenges,
    int? minutesPerChallenge,
    bool? isPrivate,
  }) {
    emit(CreateGroupFormState(
      name: name ?? state.name,
      description: description ?? state.description,
      startTime: startTime ?? state.startTime,
      endTime: endTime ?? state.endTime,
      maxSimultaneousChallenges:
          maxSimultaneousChallenges ?? state.maxSimultaneousChallenges,
      minutesPerChallenge: minutesPerChallenge ?? state.minutesPerChallenge,
      isPrivate: isPrivate ?? state.isPrivate,
    ));
    debugPrint(state.toString());
  }
}
