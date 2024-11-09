import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/usecases/db/get_group_by_id.dart';
import 'package:fitness_project/domain/usecases/db/get_users_by_ids.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MembersState {}

class MembersInitial extends MembersState {}

class MembersLoading extends MembersState {}

class MembersLoaded extends MembersState {
  final List<UserEntity> members;
  MembersLoaded({required this.members});
}

class MembersError extends MembersState {
  final String message;
  MembersError({required this.message});
}

class MembersCubit extends Cubit<MembersState> {
  final String groupId;
  final bool loadOnInit;
  MembersCubit({required this.groupId, this.loadOnInit = false})
      : super(MembersInitial()) {
    if (loadOnInit) {
      loadData();
    }
  }

  void loadData() async {
    emit(MembersLoading());
    final allowedUsers = await _fetchAllowedUsers();
    if (allowedUsers == null) {
      emit(MembersError(message: "Failed to fetch allowed users"));
      return;
    }
    allowedUsers.sort((a, b) => a.displayName.compareTo(b.displayName));
    emit(MembersLoaded(members: allowedUsers));
  }

  void addMember(UserEntity user) {
    final currentState = state;
    if (currentState is MembersLoaded) {
      if (currentState.members.map((m) => m.userId).contains(user.userId)) {
        return;
      }
      final newMembers = [...currentState.members, user];
      newMembers.sort((a, b) => a.displayName.compareTo(b.displayName));
      emit(MembersLoaded(members: newMembers));
    }
  }

  Future<GroupEntity?> _fetchGroup() async {
    final group = await sl<GetGroupByIdUseCase>().call(params: groupId);
    GroupEntity? myGroup;
    group.fold((error) {
      emit(MembersError(message: 'Failed to load group $error'));
      myGroup = null;
    }, (data) {
      myGroup = data;
    });

    return myGroup;
  }

  Future<List<UserEntity>?> _fetchAllowedUsers() async {
    final group = await _fetchGroup();
    List<UserEntity>? allowedUsers;

    if (group == null) {
      return null;
    }

    final allowedUsersFetch =
        await sl<GetUsersByIdsUseCase>().call(params: group.allowedUsers);

    allowedUsersFetch.fold((l) {
      emit(MembersError(message: l.message));
    }, (r) {
      allowedUsers = r as List<UserEntity>;
    });
    return allowedUsers;
  }
}
