import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateGroupFormState {
  String? name;
  String? description;
  DateTime? startTime;
  DateTime? endTime;
  int? maxSimultaneousChallenges;
  // int? minutesPerChallenge;
  bool isPrivate = false;
  List<UserEntity> allowedUsers;

  CreateGroupFormState({
    this.name,
    this.description,
    this.startTime,
    this.endTime,
    this.maxSimultaneousChallenges,
    // this.minutesPerChallenge,
    this.isPrivate = false,
    required this.allowedUsers,
  });
}

class CreateGroupFormCubit extends Cubit<CreateGroupFormState> {
  final List<UserEntity> allowedUsers;
  CreateGroupFormCubit({required this.allowedUsers})
      : super(CreateGroupFormState(allowedUsers: allowedUsers));

  void onValuesChanged({
    String? name,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    int? maxSimultaneousChallenges,
    // int? minutesPerChallenge,
    bool? isPrivate,
    List<UserEntity>? allowedUsers,
  }) {
    emit(CreateGroupFormState(
      name: name ?? state.name,
      description: description ?? state.description,
      startTime: startTime ?? state.startTime,
      endTime: endTime ?? state.endTime,
      maxSimultaneousChallenges:
          maxSimultaneousChallenges ?? state.maxSimultaneousChallenges,
      // minutesPerChallenge: minutesPerChallenge ?? state.minutesPerChallenge,
      isPrivate: isPrivate ?? state.isPrivate,
      allowedUsers: allowedUsers ?? state.allowedUsers,
    ));
  }

  void addMember(UserEntity user) {
    if (state.allowedUsers.map((u) => u.userId).contains(user.userId)) return;
    onValuesChanged(allowedUsers: [...state.allowedUsers, user]);
  }

  void removeMember(UserEntity user) {
    if (!state.allowedUsers.map((u) => u.userId).contains(user.userId)) return;
    onValuesChanged(
        allowedUsers:
            state.allowedUsers.where((u) => u.userId != user.userId).toList());
  }
}
