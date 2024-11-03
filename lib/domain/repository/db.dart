import 'package:dartz/dartz.dart';
import 'package:fitness_project/data/models/db/add_group_member_req.dart';
import 'package:fitness_project/data/models/db/add_submission_seen_req.dart';
import 'package:fitness_project/data/models/db/get_challenges_by_groups_req.dart';
import 'package:fitness_project/data/models/db/get_groups_by_user_req.dart';
import 'package:fitness_project/data/models/db/get_scores_by_challenge_and_user_req.dart';
import 'package:fitness_project/data/models/db/get_submission_by_challenge_and_user_req.dart';
import 'package:fitness_project/data/models/db/update_challenge_req.dart';
import 'package:fitness_project/data/models/db/update_comment_req.dart';
import 'package:fitness_project/data/models/db/update_group_req.dart';
import 'package:fitness_project/data/models/db/update_like_req.dart';
import 'package:fitness_project/data/models/db/update_submission_req.dart';
import 'package:fitness_project/data/models/db/update_user_req.dart';

abstract class DBRepository {
  Future<Either> getAllExercises();
  Future<Either> getChallengeById(String challengeId);
  Future<Either> getChallengesByGroups(
      GetChallengesByGroupsReq getChallengesByGroupsReq);
  Future<Either> getExerciseById(String exerciseId);
  Future<Either> getGroupById(String groupId);
  Future<Either> getGroupsByUser(GetGroupsByUserReq getGroupsByUserReq);
  Future<Either> getScoresBySubmission(String submissionId);
  Future<Either> getScoresByChallengeAndUser(
      GetScoresByChallengeAndUserReq getScoresByChallengeAndUserReq);
  Future<Either> getSubmissionById(String submissionId);
  Future<Either> getSubmissionByChallengeAndUser(
      GetSubmissionByChallengeAndUserReq getSubmissionByChallengeAndUserReq);
  Future<Either> getSubmissionsByChallenge(String challengeId);
  Future<Either> getSubmissionsByGroups(List<String> groupIds);
  Future<Either> getUser(String? userId);
  Future<Either> getUsersByDisplayName(String query);
  Future<Either> updateChallenge(UpdateChallengeReq updateChallengeReq);
  Future<Either> updateGroup(UpdateGroupReq updateGroupReq);
  Future<Either> updateGroupMember(UpdateGroupMemberReq updateGroupMemberReq);
  Future<Either> updateSubmission(UpdateSubmissionReq updateSubmissionReq);
  Future<Either> updateUser(UpdateUserReq updateUserReq);
  Future<Either> addSubmissionSeen(AddSubmissionSeenReq addSubmissionSeenReq);
  Future<Either> updateLike(UpdateLikeReq updateLikeReq);
  Future<Either> updateComment(UpdateCommentReq updateCommentReq);
  Future<Either> getCommentsBySubmission(String submissionId);
}
