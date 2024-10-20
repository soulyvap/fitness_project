import 'package:dartz/dartz.dart';
import 'package:fitness_project/data/db/models/add_group_member_req.dart';
import 'package:fitness_project/data/db/models/update_group_req.dart';
import 'package:fitness_project/data/db/models/update_user_req.dart';

abstract class DBRepository {
  Future<Either> updateUser(UpdateUserReq updateUserReq);
  Future<Either> updateGroup(UpdateGroupReq updateGroupReq);
  Future<Either> getUsersByDisplayName(String query);
  Future<Either> addGroupMember(AddGroupMemberReq addGroupMemberReq);
  Future<Either> getGroupsByUser(String userId);
}
