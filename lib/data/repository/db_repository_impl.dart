import 'package:dartz/dartz.dart';
import 'package:fitness_project/data/db/models/group.dart';
import 'package:fitness_project/data/db/models/update_group_req.dart';
import 'package:fitness_project/data/db/models/update_user_req.dart';
import 'package:fitness_project/data/db/models/user.dart';
import 'package:fitness_project/data/source/firestore_firebase_service.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';

class DBRepositoryImpl extends DBRepository {
  @override
  Future<Either> updateUser(UpdateUserReq updateUserReq) {
    return sl<FirestoreFirebaseService>().updateUser(updateUserReq);
  }

  @override
  Future<Either> updateGroup(UpdateGroupReq updateGroupReq) {
    return sl<FirestoreFirebaseService>().updateGroup(updateGroupReq);
  }

  @override
  Future<Either> getUsersByDisplayName(String query) async {
    final users =
        await sl<FirestoreFirebaseService>().getUsersByDisplayName(query);
    return users.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Users not found');
      }
      final List<Map<String, dynamic>> users = data;
      debugPrint('data: $users');
      final userEntities =
          users.map((e) => UserModel.fromMap(e).toEntity()).toList();
      return Right(userEntities);
    });
  }

  @override
  Future<Either> addGroupMember(addGroupMemberReq) {
    return sl<FirestoreFirebaseService>().addGroupMember(addGroupMemberReq);
  }

  @override
  Future<Either> getGroupsByUser(String userId) async {
    final groups = await sl<FirestoreFirebaseService>().getGroupsByUser(userId);
    return groups.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Groups not found');
      }
      final List<Map<String, dynamic>> groups = data;

      final groupEntities =
          groups.map((e) => GroupModel.fromMap(e).toEntity()).toList();
      debugPrint('HELLO');
      return Right(groupEntities);
    });
  }
}
