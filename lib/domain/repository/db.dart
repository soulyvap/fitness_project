import 'package:dartz/dartz.dart';
import 'package:fitness_project/data/db/models/add_group_member_req.dart';
import 'package:fitness_project/data/db/models/get_challenges_by_groups_req.dart';
import 'package:fitness_project/data/db/models/get_groups_by_user_req.dart';
import 'package:fitness_project/data/db/models/update_challenge_req.dart';
import 'package:fitness_project/data/db/models/update_group_req.dart';
import 'package:fitness_project/data/db/models/update_user_req.dart';

abstract class DBRepository {
  Future<Either> getUser(String? userId);
  Future<Either> updateUser(UpdateUserReq updateUserReq);
  Future<Either> updateGroup(UpdateGroupReq updateGroupReq);
  Future<Either> getUsersByDisplayName(String query);
  Future<Either> updateGroupMember(UpdateGroupMemberReq updateGroupMemberReq);
  Future<Either> getGroupsByUser(GetGroupsByUserReq getGroupsByUserReq);
  Future<Either> getAllExercises();
  Future<Either> updateChallenge(UpdateChallengeReq updateChallengeReq);
  Future<Either> getChallengesByGroups(
      GetChallengesByGroupsReq getChallengesByGroupsReq);
  Future<Either> getExerciseById(String exerciseId);
  Future<Either> getGroupById(String groupId);
  Future<Either> getChallengeById(String challengeId);
}
