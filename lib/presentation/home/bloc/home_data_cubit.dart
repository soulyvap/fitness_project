import 'package:fitness_project/data/db/models/get_groups_by_user_req.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/usecases/db/get_groups_by_user.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeDataState {}

class HomeDataLoading extends HomeDataState {}

class HomeDataLoaded extends HomeDataState {
  final List<GroupEntity> myGroups;

  HomeDataLoaded(this.myGroups);
}

class HomeDataError extends HomeDataState {
  final String errorMessage;

  HomeDataError(this.errorMessage);
}

class HomeDataCubit extends Cubit<HomeDataState> {
  final UserEntity currentUser;
  HomeDataCubit(this.currentUser) : super(HomeDataLoading()) {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final mygroups = await _fetchMyGroups();
      if (mygroups != null) {
        debugPrint('mygroups: $mygroups');
        emit(HomeDataLoaded(mygroups));
      }
    } catch (e) {
      emit(HomeDataError(e.toString()));
    }
  }

  Future<List<GroupEntity>?> _fetchMyGroups() async {
    final groups = await sl<GetGroupsByUserUseCase>()
        .call(params: GetGroupsByUserReq(userId: currentUser.userId));
    List<GroupEntity>? myGroups;
    groups.fold((error) {
      emit(HomeDataError('Failed to load groups'));
      myGroups = null;
    }, (data) {
      myGroups = data;
    });
    return myGroups;
  }
}
